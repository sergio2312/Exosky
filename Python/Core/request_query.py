from astroquery.gaia import Gaia
import numpy as np


def get_astromeric_at_exoplanet(ra, dec, parallax, grvs, ra_exoplanet, dec_exoplanet, parallax_exoplanet):
    def get_xyz_from_astromerics(ra, dec, parallax):
        # ra and dec are given in degrees
        # parallax is given in arcseconds. The distance d is calculated as
        # 1/parallax when given in parsecs (1 parsec = 32.6 lightyears)
        x = 1e3 / parallax * np.cos(ra * np.pi / 180) * np.sin(dec * np.pi / 180)
        y = 1e3 / parallax * np.sin(ra * np.pi / 180) * np.sin(dec * np.pi / 180)
        z = 1e3 / parallax * np.cos(dec * np.pi / 180)
        return x, y, z

    x, y, z = get_xyz_from_astromerics(ra, dec, parallax)
    x_exoplanet, y_exoplanet, z_exoplanet = get_xyz_from_astromerics(ra_exoplanet, dec_exoplanet, parallax_exoplanet)

    r = np.array([x-x_exoplanet, y-y_exoplanet, z-z_exoplanet])

    grvs_exoplanet = grvs + 5* np.log10(np.linalg.norm(r)/np.linalg.norm([x, y, z]))

    r = r/np.linalg.norm(r)
    radius = 4 / grvs_exoplanet

    return r[0], r[1], r[2], radius


def write_txt(name: str, results):
    with open(name + '.txt', 'w') as f:
        for i in range(len(results)):
            data = get_astromeric_at_exoplanet(results['ra'][i],
                                               results['dec'][i],
                                               results['parallax'][i],
                                               results['grvs_mag'][i],
                                               ra_exoplanet,
                                               dec_exoplanet,
                                               parallax_exoplanet)
            if data[3] < 0:
                continue
            line = (str(data[0]) + '; ' + str(data[1]) + '; ' + str(data[2]) +
                    '; ' + str(data[3]) + '; ' + str(results['pseudocolour'][i]) +
                    '; ' + str(results['classprob_dsc_combmod_quasar'][i]) +
                    '; ' + str(results['classprob_dsc_combmod_galaxy'][i]) +
                    '; ' + str(results['classprob_dsc_combmod_star'][i]) +
                    '; ' + str(results['teff_gspphot'][i]) + '\n')
            f.write(line)


def HH_MM_SS_to_degrees(hh, mm, ss):
    return 360/24 * hh + 1/60 * mm + 1/240 * ss


def deg_arcmin_arcsecs_to_degrees(deg, arcmin, arcsecs):
    return np.sign(deg)*(np.abs(deg) + 1/60*arcmin + 1/3600*arcsecs)


exoplanets = {
    "HIP_65_A_b": [HH_MM_SS_to_degrees(0, 0, 44.5),
                   deg_arcmin_arcsecs_to_degrees(-54, 49, 50.96),
                   1000/61.7856],
    "HD_12235_b": [HH_MM_SS_to_degrees(2, 0, 9.4),
                   deg_arcmin_arcsecs_to_degrees(3, 5, 45.28),
                   1000 / 31.7627],
    "K2-83_c": [HH_MM_SS_to_degrees(3, 59, 36.33),
                deg_arcmin_arcsecs_to_degrees(15, 33, 31.68),
                1000 / 125.529],
    "TOI-2497_b": [HH_MM_SS_to_degrees(6, 0, 15.02),
                   deg_arcmin_arcsecs_to_degrees(11, 53, 2.61),
                   1000 / 285.289],
    "GJ_3470_b": [HH_MM_SS_to_degrees(7, 59, 5.64),
                  deg_arcmin_arcsecs_to_degrees(15, 23, 28.35),
                  1000 / 29.4241],
    "TOI-1775_b": [HH_MM_SS_to_degrees(10, 0, 27.62),
                   deg_arcmin_arcsecs_to_degrees(39, 27, 27.9),
                   1000 / 149.234],
    "K2_158_c": [HH_MM_SS_to_degrees(11, 59, 45.53),
                 deg_arcmin_arcsecs_to_degrees(-5, 43, 18.08),
                 1000 / 197.299],
    "WASP-131_b": [HH_MM_SS_to_degrees(14, 0, 46.46),
                   deg_arcmin_arcsecs_to_degrees(-30, 35, 0.99),
                   1000 / 200.075],
    "WASP-17_b": [HH_MM_SS_to_degrees(15, 59, 50.94),
                  deg_arcmin_arcsecs_to_degrees(-28, 3, 42.46),
                  1000 / 405.908],
    "OGLE-2018-BLG-0532L_b": [HH_MM_SS_to_degrees(17, 59, 56.02),
                              deg_arcmin_arcsecs_to_degrees(-28, 59, 51.9),
                              1000 / 773],
    "Kepler-1118_b": [HH_MM_SS_to_degrees(19, 59, 51.76),
                      deg_arcmin_arcsecs_to_degrees(44, 9, 39.17),
                      1000 / 888.325],
    "HD_208897_B": [HH_MM_SS_to_degrees(21, 58, 59.87),
                    deg_arcmin_arcsecs_to_degrees(19, 1, 12.57),
                    1000 / 67.4872],
}


for exoplanet, coords in exoplanets.items():
    ra_exoplanet, dec_exoplanet, parallax_exoplanet = coords[0], coords[1], coords[2]
    print(exoplanet, ': ', ra_exoplanet, dec_exoplanet, parallax_exoplanet)

    condition = ('(parallax IS NOT NULL AND parallax > 0 AND ' +
                 'grvs_mag + 5 * LOG10(SQRT(' +
                 'POWER(COS(ra*PI()/180)*SIN(dec*PI()/180)/parallax - COS({0}*PI()/180)*SIN({1}*PI()/180)/{2},2) + ' +
                 'POWER(SIN(ra*PI()/180)*SIN(dec*PI()/180)/parallax - SIN({0}*PI()/180)*SIN({1}*PI()/180)/{2},2) + ' +
                 'POWER(COS(dec*PI()/180)/parallax - COS({1}*PI()/180)/{2},2))*parallax) BETWEEN 0.1 AND 5)'
                 ).format(ra_exoplanet, dec_exoplanet, parallax_exoplanet)

    query = ("SELECT TOP 5000 ra, dec, parallax, grvs_mag, pseudocolour, classprob_dsc_combmod_quasar, " +
             "classprob_dsc_combmod_galaxy, classprob_dsc_combmod_star, teff_gspphot FROM gaiadr3.gaia_source WHERE "
             + condition)

    print(query)

    job = Gaia.launch_job_async(query)
    results = job.get_results()

    write_txt(exoplanet, results)
