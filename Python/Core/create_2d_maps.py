import numpy as np
from matplotlib import pyplot as plt
import os

THRESHOLD = 1.3

def wavelength_to_rgb(wavelength):
    if wavelength is None:
        return (1,1,1)
    gamma = 0.8
    intensity_max = 255

    if (wavelength >= 380) and (wavelength < 440):
        R = -(wavelength - 440) / (440 - 380)
        G = 0.0
        B = 1.0
    elif (wavelength >= 440) and (wavelength < 490):
        R = 0.0
        G = (wavelength - 440) / (490 - 440)
        B = 1.0
    elif (wavelength >= 490) and (wavelength < 510):
        R = 0.0
        G = 1.0
        B = -(wavelength - 510) / (510 - 490)
    elif (wavelength >= 510) and (wavelength < 580):
        R = (wavelength - 510) / (580 - 510)
        G = 1.0
        B = 0.0
    elif (wavelength >= 580) and (wavelength < 645):
        R = 1.0
        G = -(wavelength - 645) / (645 - 580)
        B = 0.0
    elif (wavelength >= 645) and (wavelength <= 750):
        R = 1.0
        G = 0.0
        B = 0.0
    else:
        R = G = B = 0  # wavelength is outside the visible range

    # Let the intensity fall off near the vision limits
    if (wavelength >= 380) and (wavelength < 420):
        factor = 0.3 + 0.7*(wavelength - 380) / (420 - 380)
    elif (wavelength >= 420) and (wavelength < 645):
        factor = 1.0
    elif (wavelength >= 645) and (wavelength <= 750):
        factor = 0.3 + 0.7*(750 - wavelength) / (750 - 645)
    else:
        factor = 0.0

    R = int(intensity_max * (R * factor)**gamma/255)
    G = int(intensity_max * (G * factor)**gamma/255)
    B = int(intensity_max * (B * factor)**gamma/255)

    return R, G, B


exoplanet_name = 'TOI-2497_b'

with open('./Exoplanets/' + exoplanet_name + '.txt', 'r') as f:
    star_positions = []
    star_positions_stereographic_positive_z = []
    star_positions_stereographic_negative_z = []
    star_positions_mercator = []
    for line in f:
        data = line.split('; ')
        x = float(data[0])
        y = float(data[1])
        z = float(data[2])
        radius = 3 if float(data[3]) > THRESHOLD else 0.2
        color = (1, 1, 1)
        star_positions.append((x, y, z, radius, color))
        if z > 0:
            X = 2*x/(1+z)
            Y = 2*y/(1+z)
            star_positions_stereographic_positive_z.append((X, Y, radius, color))
        elif z <= 0:
            X = 2*x/(1-z)
            Y = 2*y/(1-z)
            star_positions_stereographic_negative_z.append((X, Y, radius, color))
        theta = np.arctan(z/(x**2+y**2))
        phi = np.arctan(y/x)
        star_positions_mercator.append((phi, theta, radius, color))


THETA = np.linspace(0, 2*np.pi, 200)
CIRCLE_X = 2.1*np.cos(THETA)
CIRCLE_Y = 2.1*np.sin(THETA)

try:
    os.mkdir(exoplanet_name + '_maps')
except FileExistsError:
    pass


fig, ax = plt.subplots(figsize=(10, 10))
for pointX, pointY, _, radius, color in star_positions:
    ax.plot(pointX, pointY, 'o', c=color, markersize=radius)
plt.axis('off')
plt.savefig('./' + exoplanet_name + '_maps/projection.png', dpi=300, bbox_inches='tight', transparent=True)

fig, ax = plt.subplots(figsize=(10, 10))
for pointX, pointY, radius, color in star_positions_stereographic_positive_z:
    ax.plot(pointX, pointY, 'o', c=color, markersize=radius)
ax.plot(CIRCLE_X, CIRCLE_Y, 'w', linewidth=0.5)
plt.axis('off')
plt.savefig('./' + exoplanet_name + '_maps/stereographic_positive.png', dpi=300, bbox_inches='tight', transparent=True)


fig, ax = plt.subplots(figsize=(10, 10))
for pointX, pointY, radius, color in star_positions_stereographic_negative_z:
    ax.plot(pointX, pointY, 'o', c=color, markersize=radius)
ax.plot(CIRCLE_X, CIRCLE_Y, 'w', linewidth=0.5)
plt.axis('off')
plt.savefig('./' + exoplanet_name + '_maps/stereographic_negative.png', dpi=300, bbox_inches='tight',transparent=True)


fig, ax = plt.subplots(figsize=(20, 10))
for pointX, pointY, radius, color in star_positions_mercator:
    ax.plot(pointX, pointY, 'o', c=color, markersize=radius)
plt.axis('off')
plt.savefig('./' + exoplanet_name + '_maps/mercator.png', dpi=300, bbox_inches='tight',transparent=True)
