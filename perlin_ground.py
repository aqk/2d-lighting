#!/usr/bin/env python

import matplotlib.pyplot as plt
from perlin_noise import PerlinNoise
from poissondisc import PoissonDisc

noise1 = PerlinNoise(octaves=5)
xpix, ypix = 256, 256
pd = PoissonDisc(noise1, {
    'width': xpix,
    'height': ypix,
    'side': 1,
    'mindist': 2.0
})
pic = [[noise1([i/xpix, j/ypix]) for j in range(xpix)] for i in range(ypix)]
for point in pd.scatter_points():
    if point[1]:
        x = point[0][0]
        y = point[0][1]
        pic[y][x] = 1.0

plt.imshow(pic, cmap='gray')
plt.show()
