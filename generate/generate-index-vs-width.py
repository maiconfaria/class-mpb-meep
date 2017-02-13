'''
Documentation, License etc.

@package generate
'''
import numpy as np
import matplotlib.pyplot as plt
import os
import h5py

a = []
widths = np.arange(0.120, 0.230, 0.1)
print widths

mpb_in_wg_dim = {'one':'wg_1D_slab.ctl' , 'two':'wg_2D_strip.ctl' }

#########################################################
# Runs mpb for several waveguide's widths and append the results
# to a list 'a'. The results related to allowed bands are given
# in a output line marked with kvals flag. 
for i in widths: 
    cmd = "mpb  W="+str(i)+" l=1.550 LY=20 LZ=20 resolution=32 ../waveguide/"+mpb_in_wg_dim['two']+" | grep kvals"
    a.append(os.popen(cmd).read())
    
a = np.genfromtxt(a, delimiter=",") # convert 'a' in a array

# select the band propagation constant beta and calculates the effective index = beta mode / frequency
# beta vals: frequency, band-min, band-max, beta dir1, beta dir2, beta dir3, beta mode1, ..., beta mode4
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
