#!/usr/bin/env python

import matplotlib.pyplot as plt
from perlin_noise import PerlinNoise
from poissondisc import PoissonDisc

noise1 = PerlinNoise(octaves=5)
xpix, ypix = 64, 64
pd = PoissonDisc(noise1, {
    'width': xpix,
    'height': ypix,
    'side': 1,
    'mindist': 2.0
})
pic = [[noise1([i/xpix, j/ypix]) for j in range(xpix)] for i in range(ypix)]
scatter = list(pd.scatter_points())
print('got scatter',len(scatter))
for i in range(500):
    print(i)
    for pi in range(len(scatter)):
        (x,y),junk = scatter[pi]
        noise_at = pic[int(y/ypix)][int(x/xpix)]
        if y >= 1:
            noise_above = pic[int(y/ypix - 1)][int(x/xpix)] - noise_at
        else:
            noise_above = 0
        if x >= 1:
            noise_left = pic[int(y/ypix)][int(x/xpix - 1)] - noise_at
        else:
            noise_left = 0
        scatter[pi] = ((x + 150 * noise_left, y + 150 * noise_above),junk)

for p in scatter:
    xi = int(p[0][0])
    yi = int(p[0][1])
    try:
        pic[yi][xi] = 1.0
    except:
        print(xi,yi)
        pass

plt.imshow(pic, cmap='gray')
plt.show()
