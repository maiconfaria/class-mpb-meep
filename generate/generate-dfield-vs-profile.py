'''
Documentation, License etc.

@package generate
'''
import numpy as np
import matplotlib.pyplot as plt
import os
import h5py

# Look at generate-index-vs-width.py to get the parameters:
LY=40.
resolution=64.
width=0.220

x = np.arange(-LY/2., LY/2., 1./resolution)
h5f = h5py.File('wg_1D_slab_neff-dpwr.k01.b02.h5','r')
b = h5f['data'][0]
h5f.close()

plt.plot( x, b/max(b) , '--')
plt.xlim((-1,1))
plt.ylabel('Electric Energy Density (a.u)')
plt.xlabel('distance (nm)')
plt.vlines(-width/2, 0, 1)
plt.vlines(width/2, 0, 1)
plt.show()