import numpy as np
import matplotlib.pyplot as plt

A = np.array([0.5, 0.05, 0.15, 0.5, 0, 0.3, 0, 0, 0, 0, 0.2]);
phi = np.array([0, 1.5, 0.8, -0.2, 0, -1.2, -0.6, 0, 0, 0, 0, -0.6]);
f_0 = 100
N = 512
T_0 = 1/f_0
tt = np.arange(0, T_0, T_0/N)

for k in range(0,11):
    x = A[k] * np.cos(2*np.pi*k*f_0*tt + phi[k])
plt.plot(tt[1:100], x[1:100])
plt.show()
