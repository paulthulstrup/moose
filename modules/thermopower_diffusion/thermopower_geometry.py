import os, subprocess, re, sys
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd


# Modify mesh size for all , we set:
#        - T_fridge = 0.005
#        - T_hot = 0.3


def writeMooseInput(mesh_n):
    Values = {
        'mesh_name': mesh_n

    }

    # First part is reading the text file with
    Lines = [line.rstrip('\n') for line in open('./input_file_geovar.txt')]

    # Write a list tuple  {line number thing to change}
    Lines_to_change = {
        '1': "mesh_name",

    }

    filename = "./thermopower_diffusion.i"
    os.remove(filename)

    content = ''

    for i in range(len(Lines)):
        l = Lines[i]

        key = str(i)
        if key in Lines_to_change:
            l += Values[Lines_to_change[key]] + "'"

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


# Set up environment variable
# meshes = ['advanced_L_2.msh', 'advanced_L_4.msh', 'advanced_L_6.msh', 'advanced_L_9.msh',
#           'advanced_L_10.msh', 'advanced_L_11.msh', 'advanced_L_13.msh', 'advanced_L_20.msh',
#           'advanced_L_30.msh', 'advanced_L_40.msh', 'advanced_L_100.msh']
# meshes_length = [2, 4, 6, 9, 10, 11, 13, 20, 30, 40, 100]

meshes = ['rectangle2.msh', 'rectangle2-5.msh', 'rectangle3.msh', 'rectangle3-5.msh', 'rectangle4.msh', 'rectangle6.msh',
          'rectangle8.msh', 'rectangle10.msh']
meshes_length = [2, 2.5, 3, 3.5, 4, 6, 8, 10]

result1 = []
result2 = []
result3 = []
result4 = []
result5 = []

for i in range(len(meshes)):
    mesh = meshes[i]
    writeMooseInput(mesh)
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

    if meshes_length[i] == 2:
        grid_x, grid_y = np.mgrid[min(x_node):max(x_node):100j,
                         min(y_node):max(y_node):100j]  # here we manually define the range of the mesh
        grid_T1 = griddata(nodes, val_T, (grid_x, grid_y), method='cubic')
        result1.append(grid_T1[10, 50])
        result2.append(grid_T1[30, 50])
        result3.append(grid_T1[50, 50])
        result4.append(grid_T1[70, 50])
        result5.append(grid_T1[90, 50])

    if meshes_length[i] == 2.5:
        grid_x, grid_y = np.mgrid[min(x_node):max(x_node):125j,
                         min(y_node):max(y_node):125j]  # here we manually define the range of the mesh
        grid_T1 = griddata(nodes, val_T, (grid_x, grid_y), method='cubic')
        result1.append(grid_T1[10, 62])
        result2.append(grid_T1[30, 62])
        result3.append(grid_T1[50, 62])
        result4.append(grid_T1[70, 62])
        result5.append(grid_T1[90, 62])

    elif meshes_length[i] == 3:
        grid_x, grid_y = np.mgrid[min(x_node):max(x_node):150j,
                         min(y_node):max(y_node):150j]  # here we manually define the range of the mesh
        grid_T1 = griddata(nodes, val_T, (grid_x, grid_y), method='cubic')
        result1.append(grid_T1[10, 75])
        result2.append(grid_T1[30, 75])
        result3.append(grid_T1[50, 75])
        result4.append(grid_T1[70, 75])
        result5.append(grid_T1[90, 75])

    elif meshes_length[i] == 3.5:
        grid_x, grid_y = np.mgrid[min(x_node):max(x_node):175j,
                         min(y_node):max(y_node):175j]  # here we manually define the range of the mesh
        grid_T1 = griddata(nodes, val_T, (grid_x, grid_y), method='cubic')
        result1.append(grid_T1[10, 87])
        result2.append(grid_T1[30, 87])
        result3.append(grid_T1[50, 87])
        result4.append(grid_T1[70, 87])
        result5.append(grid_T1[90, 87])

    elif meshes_length[i] == 4:
        grid_x, grid_y = np.mgrid[min(x_node):max(x_node):200j,
                         min(y_node):max(y_node):200j]  # here we manually define the range of the mesh
        grid_T1 = griddata(nodes, val_T, (grid_x, grid_y), method='cubic')
        result1.append(grid_T1[10, 100])
        result2.append(grid_T1[30, 100])
        result3.append(grid_T1[50, 100])
        result4.append(grid_T1[70, 100])
        result5.append(grid_T1[90, 100])

    elif meshes_length[i] == 6:
        grid_x, grid_y = np.mgrid[min(x_node):max(x_node):300j,
                         min(y_node):max(y_node):300j]  # here we manually define the range of the mesh
        grid_T1 = griddata(nodes, val_T, (grid_x, grid_y), method='cubic')
        result1.append(grid_T1[10, 150])
        result2.append(grid_T1[30, 150])
        result3.append(grid_T1[50, 150])
        result4.append(grid_T1[70, 150])
        result5.append(grid_T1[90, 150])

    elif meshes_length[i] == 8:
        grid_x, grid_y = np.mgrid[min(x_node):max(x_node):400j,
                         min(y_node):max(y_node):400j]  # here we manually define the range of the mesh
        grid_T1 = griddata(nodes, val_T, (grid_x, grid_y), method='cubic')
        result1.append(grid_T1[10, 200])
        result2.append(grid_T1[30, 200])
        result3.append(grid_T1[50, 200])
        result4.append(grid_T1[70, 200])
        result5.append(grid_T1[90, 200])

    elif meshes_length[i] == 9:
        grid_x, grid_y = np.mgrid[min(x_node):max(x_node):450j,
                         min(y_node):max(y_node):450j]  # here we manually define the range of the mesh
        grid_T1 = griddata(nodes, val_T, (grid_x, grid_y), method='cubic')
        result1.append(grid_T1[33, 225])

    elif meshes_length[i] == 10:
        grid_x, grid_y = np.mgrid[min(x_node):max(x_node):500j,
                         min(y_node):max(y_node):500j]  # here we manually define the range of the mesh
        grid_T1 = griddata(nodes, val_T, (grid_x, grid_y), method='cubic')
        result1.append(grid_T1[10, 250])
        result2.append(grid_T1[30, 250])
        result3.append(grid_T1[50, 250])
        result4.append(grid_T1[70, 250])
        result5.append(grid_T1[90, 250])

    elif meshes_length[i] == 11:
        grid_x, grid_y = np.mgrid[min(x_node):max(x_node):550j,
                         min(y_node):max(y_node):550j]  # here we manually define the range of the mesh
        grid_T1 = griddata(nodes, val_T, (grid_x, grid_y), method='cubic')
        result1.append(grid_T1[33, 275])

    elif meshes_length[i] == 13:
        grid_x, grid_y = np.mgrid[min(x_node):max(x_node):650j,
                         min(y_node):max(y_node):650j]  # here we manually define the range of the mesh
        grid_T1 = griddata(nodes, val_T, (grid_x, grid_y), method='cubic')
        result1.append(grid_T1[33, 325])


    elif meshes_length[i] == 20:
        grid_x, grid_y = np.mgrid[min(x_node):max(x_node):1000j,
                         min(y_node):max(y_node):1000j]  # here we manually define the range of the mesh
        grid_T1 = griddata(nodes, val_T, (grid_x, grid_y), method='cubic')
        result1.append(grid_T1[12, 500])

    elif meshes_length[i] == 30:
        grid_x, grid_y = np.mgrid[min(x_node):max(x_node):1500j,
                         min(y_node):max(y_node):1500j]  # here we manually define the range of the mesh
        grid_T1 = griddata(nodes, val_T, (grid_x, grid_y), method='cubic')
        result1.append(grid_T1[12, 750])

    elif meshes_length[i] == 40:
        grid_x, grid_y = np.mgrid[min(x_node):max(x_node):2000j,
                         min(y_node):max(y_node):2000j]  # here we manually define the range of the mesh
        grid_T1 = griddata(nodes, val_T, (grid_x, grid_y), method='cubic')
        result1.append(grid_T1[12, 1000])

    elif meshes_length[i] == 100:
        grid_x, grid_y = np.mgrid[min(x_node):max(x_node):5000j,
                         min(y_node):max(y_node):5000j]  # here we manually define the range of the mesh
        grid_T1 = griddata(nodes, val_T, (grid_x, grid_y), method='cubic')
        result1.append(grid_T1[12, 2500])

print result5
