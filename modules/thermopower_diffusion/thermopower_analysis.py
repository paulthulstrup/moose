import numpy as np
import matplotlib.pyplot as plt
import pandas as pd

# Data Import
T_hot = np.arange(0.010,0.5, 0.005)
T_fridge = np.arange(0.005,0.495, 0.005)

df = pd.read_csv("./data/TVar_Thot-0.01-0.495-step0.005_Tcold-0.005-0.49.csv", )
data = df.values

index = 25
T_hot_val = T_hot[index]
T_meas = data[index]

x = []
y = []

for i in range(len(T_meas)):
    if T_meas[i] > 0:
        x.append(T_fridge[i])
        y.append(T_meas[i] - T_fridge[i])

plt.xlabel("Fridge temperature (in K)")
plt.ylabel("Temperature at L curvature")
title = "Temperature measured vs Fridge Temperature for T_hot = " + str(T_hot_val) + "K"
plt.title(title)
plt.plot(x, y, "+")
plt.show()






dict_temp = {}
for i in range(len(T_hot)):
    t_data = data[i]

    for j in range(len(t_data)):
        if t_data[j] > 0:
            dict_temp[T_hot[i], T_fridge[j]] = t_data[j] - T_fridge[j]

keys = dict_temp.keys()
temperature = [];
t_hot = [];
t_fridge = []
for key in keys:
    temperature.append(float(dict_temp[key]))
    t_hot.append(float(key[0]))
    t_fridge.append(float(key[1]))


color_by = temperature
label = '$T_{e}-T_{p}$ at center of curvature'
max_color_by = max(color_by)
min_color_by = min(color_by)


fig, ax = plt.subplots()
s = ax.scatter(t_hot, t_fridge,
               c=color_by,
               s=20,
               marker='o',                   # Plot circles
              # alpha = 0.2,
               cmap = plt.cm.coolwarm,       # Color pallete
               vmin = min_color_by,          # Min value
               vmax = max_color_by)          # Max value

cbar = plt.colorbar(mappable = s, ax = ax)   # Mappable 'maps' the values of s to an array of RGB colors defined by a color palette
cbar.set_label(label)
plt.xlabel('$T_{e}-T_{p}$ (K)')
plt.ylabel('Fridge temperature (K)')
plt.show()