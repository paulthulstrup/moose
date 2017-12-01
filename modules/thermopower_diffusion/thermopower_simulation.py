import os, subprocess, re, sys
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd

def writeMooseInput(T_high, T_frige):
    Values = {
        'T_cold': str(np.square(T_frige)),
        'T_high': str(np.square(T_high))

    }

    # First part is reading the text file with
    Lines = [line.rstrip('\n') for line in open('./input_file_thermopower.txt')]

    # Write a list tuple  {line number thing to change}
    Lines_to_change = {
        '31': 'T_cold',
        '45': 'T_cold',
        '53': 'T_high',
    }

    filename = "./thermopower_diffusion.i"
    os.remove(filename)

    content = ''

    for i in range(len(Lines)):
        l = Lines[i]

        key = str(i)
        if key in Lines_to_change:
            l += Values[Lines_to_change[key]]

        content += l
        content += '\n'

    with open(filename, 'w+') as f2:
        f2.write(content + os.linesep)


# Run the Moose simulation
def runMoose():
    run_cmd = "sh ./run_sim_thermopower.sh"
    subprocess.call(run_cmd, shell=True)


# Cleans the variable to rturn an array of floats
def clean_var(var):
    temp = re.sub('', '', var[0])
    mylist = temp.split(',')

    res = []
    for i in range(len(mylist)):
        s = mylist[i]
        res.append(re.sub('[\s+]', '', s))

    res = [float(i) for i in res]
    return res


# Cretes the filename in which we will
def createFilename(T_h, T_c):
    location = "./data/TVar"

    if len(T_h)>1:
        Thot_txt = "_Thot-" + str(min(T_h)) + "-" + str(max(T_h)) + "-step" + str(T_h[1]-T_h[0])
    else:
        Thot_txt = "_Thot-" + str(T_h[0])

    if len(T_c)>1:
        Tcold_txt = "_Tcold-" + str(min(T_c)) + "-" + str(max(T_c))
    else:
        Tcold_txt = "_Tcold-" + str(T_c[0])

    filename = location + Thot_txt + Tcold_txt + ".csv"

    answer = ""

    if os.path.isfile(filename):
        print "WARNING: file already exists!"
        while True:
            answer = raw_input("Do you wish to continue? [y/n]: ")

            if answer == "n":
                sys.exit(1)
            elif answer == "y":
                break
            else:
                print "Please enter either <y> or <n> only!"
                print "\n"

    print "Starting simulation"

    return filename


# Set up environment variable
T_hot = np.arange(0.010,0.5, 0.005)
T_fridge = np.arange(0.005,0.495, 0.005)

result = np.zeros((len(T_hot), len(T_fridge)))

for i in range(len(T_hot)):

    t_hot = T_hot[i]
    print("")
    print("T_high = " + str(t_hot))

    T_temp = []

    for j in range(len(T_fridge)):

        t_cold = T_fridge[j]
        print("\tT_fridge = " + str(t_cold))

        if t_cold > t_hot:
            break

        writeMooseInput(t_hot, t_cold)

        runMoose()

        # Loads the data from the nbdcump function
        f = open("out.txt", 'r')

        data = f.read()

        x = re.findall(r'coordx =(.*?);', data, re.DOTALL)
        x_node = clean_var(x)

        y = re.findall(r'coordy =(.*?);', data, re.DOTALL)
        y_node = clean_var(y)

        nodes = np.array(zip(x_node, y_node))

        T = re.findall(r'vals_nod_var1 =(.*?);', data, re.DOTALL)
        val_T = np.sqrt(clean_var(T))

        # Interpolation (Linear or Cubic)
        # Need to define the domain properly on which we interpolate
        from scipy.interpolate import griddata

        grid_x, grid_y = np.mgrid[min(x_node):max(x_node):200j, min(y_node):max(y_node):200j]  # here we manually define the range of the mesh
        grid_T1 = griddata(nodes, val_T, (grid_x, grid_y), method='linear')

        # Choose where we want to extract temperature
        result[i,j] = grid_T1[25,25] # IMPORTANT THIS IS FOR NORMAL L MESH


# Save to csv file
p = pd.DataFrame(result)
p.to_csv(createFilename(T_hot, T_fridge))
