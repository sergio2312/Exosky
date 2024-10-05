import requests

url = "https://exoplanetarchive.ipac.caltech.edu/cgi-bin/nstedAPI/nph-nstedAPI?"
full_url = '''https://exoplanetarchive.ipac.caltech.edu/cgi-bin/nstedAPI/nph-nstedAPI?table=cumulative
            &where=koi_disposition%20like%20%27CANDIDATE%27
            &where=koi_period%3E300,koi_prad%3C2
            &order=koi_period
            &format=csv'''

response = requests.get(full_url)
if response.status_code == 200:
    with open("out_req.csv", "w") as file:
        file.write(response.text)


