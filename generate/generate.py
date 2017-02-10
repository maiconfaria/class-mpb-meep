'''
Documentation, License etc.

@package generate
'''
import numpy as np
import matplotlib.pyplot as plt
import os
import h5py

a = []
widths = np.arange(0.010, 0.400, 0.1)
for i in widths: 
    cmd = "mpb  W="+str(i)+" l=1.550 ../waveguide/wg_1D_slab_neff.ctl | grep kvals"
    a.append(os.popen(cmd).read())
    
a = np.genfromtxt(a, delimiter=",")

n_eff_TE0 = a[:,10]/a[:,1]
n_eff_TM0 = a[:,11]/a[:,1]
n_eff_TE1 = a[:,12]/a[:,1]
n_eff_TM1 = a[:,13]/a[:,1]

plt.plot( widths, n_eff_TE0, 'ro-', widths, n_eff_TM0, 'bs-', widths, n_eff_TE1, 'rs-', widths, n_eff_TM1, 'bs-')
plt.legend(["TE0","TM0","TE1","TM1"],loc='upper left')
plt.annotate("Single mode cutoff (TE, TM)", xy=(0.2,0.9), xycoords = 'axes fraction')
plt.ylabel('Effective Index')
plt.xlabel('Slab Thickness[nm]')
plt.show()
#x = np.arange(-15.5/2, 15.5/2, 1/32)
#h5f = h5py.File('../waveguide/wg_1D_slab_neff-dpwr.k01.b01.h5','r')
#b = h5f['data'][0]
#h5f.close()

#plt.plot( x, b, '--')
#plt.show()