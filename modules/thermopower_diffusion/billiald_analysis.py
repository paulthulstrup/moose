import numpy as np
import matplotlib.pyplot as plt
import pandas as pd


def computeSquareError(y_pred, y):
    y_pred_array = np.asarray(y_pred)
    y_array = np.asarray(y)
    return np.mean((y_array - y_pred_array)**2)


# sets up pandas table display
df4 = pd.read_csv("./data/T_4_lowV_alpha-0.02-1.98-step0.04_beta-81967213.1148.csv", header=None,
                  names=["alpha", "beta", "100nA", "200nA", "300nA", "400nA", "500nA", "600nA", "700nA", "800nA",
                         "900nA", "1000nA"])
df5 = pd.read_csv("./data/T_5_lowV_alpha-3.7-5.65-step0.05_beta-81967213.1148.csv", header=None,
                  names=["alpha", "beta", "100nA", "200nA", "300nA", "400nA", "500nA", "600nA", "700nA", "800nA",
                         "900nA", "1000nA"])

df6 = pd.read_csv("./data/T_6_alpha-28.0-29.9-step0.1_beta-81967213.1148.csv", header=None,
                  names=["alpha", "beta", "100nA", "200nA", "300nA", "400nA", "500nA", "600nA", "700nA", "800nA",
                         "900nA", "1000nA"])

# Choose the index here:
index3 = index4 = index5 = index6 = 0
err_min = 0
I = np.arange(100,1100,100)*1E-9
trend = [np.power(i,1.6) * (3E-3 / np.power(100E-9, 1.6)) for i in I]

# Power of 4
l4=df4.iloc[:,:].values

for idx4 in range(l4.shape[0]):
    Temp4 = l4[idx4].flatten()[2:]
    T4 = [x - 0.170 for x in Temp4]
    error = computeSquareError(trend, T4)
    if idx4 == 0:
        index4 = idx4
        err_min = error

    elif error < err_min:
        index4 = idx4
        err_min = error


# Power of 5
l5=df5.iloc[:,:].values
for idx5 in range(l5.shape[0]):
    Temp5 = l5[idx5].flatten()[2:]
    T5 = [x - 0.170 for x in Temp5]
    error = computeSquareError(trend, T5)
    if idx5 == 0:
        index5 = idx5
        err_min = error

    elif error < err_min:
        index5 = idx5
        err_min = error

# Power of 6
l6=df6.iloc[:,:].values

for idx6 in range(l6.shape[0]):
    Temp6 = l6[idx6].flatten()[2:]
    T6 = [x - 0.170 for x in Temp6]
    error = computeSquareError(trend, T6)
    if idx6 == 0:
        index6 = idx6
        err_min = error

    elif error < err_min:
        index6 = idx6
        err_min = error



Temp4 = l4[index4].flatten()[2:]
T4 = [x - 0.170 for x in Temp4]
Temp5 = l5[index5].flatten()[2:]
T5 = [x - 0.170 for x in Temp5]
Temp6 = l6[index6].flatten()[2:]
T6 = [x - 0.170 for x in Temp6]


## PLOTING ##
plt.close('all')
f, axarr = plt.subplots(2, 2)
axarr[0, 0].loglog(I,trend)
axarr[0, 0].set_title('Power of 3')

axarr[0, 1].loglog(I, T4,"o", basex=10)
axarr[0, 1].loglog(I,trend)
axarr[0, 1].set_title('Power of 4')

axarr[1, 0].loglog(I, T5,"o", basex=10)
axarr[1, 0].loglog(I,trend)
axarr[1, 0].set_title('Power of 5')

axarr[1, 1].loglog(I, T6,"o", basex=10)
axarr[1, 1].loglog(I,trend)
axarr[1, 1].set_title('Power of 6')

# Fine-tune figure; hide x ticks for top plots and y ticks for right plots
plt.setp([a.get_xticklabels() for a in axarr[0, :]], visible=False)
plt.setp([a.get_yticklabels() for a in axarr[:, 1]], visible=False)
plt.show()

# Print the values of the alphas
#print "Alpha T^3 = " + str(l3[index3])
print "Alpha T^4 = " + str(l4[index4,0])
print "Alpha T^5 = " + str(l5[index5,0])
print "Alpha T^6 = " + str(l6[index6,0])
