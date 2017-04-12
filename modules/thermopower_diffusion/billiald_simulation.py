# -*- coding: utf-8 -*-
# P.Thulstrup 03/13/2017
#


# LIBRARIES
import os
import re
import numpy as np
import subprocess
import csv


# FUNCTIONS

# argument: alpha, beta, T_frige, T_hot
def writeMooseInput(alpha, beta, T_frige, V):
    
    Values = {
    'alpha': str(alpha), 
    'beta': str(beta), 
    'T_cold': str(np.square(T_frige)), 
    'DV': str(V)
    }

    # First part is reading the text file with     
    Lines = [line.rstrip('\n') for line in open('./input_file_billiald.txt')]
    
    # Write a list tuple  {line number thing to change} 
    Lines_to_change = {
                       '31': 'T_cold', 
                       '45': 'T_cold', 
                       '52': 'T_cold', 
                       '60': 'T_cold', 
                       '67': 'DV',
                       '83': 'alpha', 
                       '84': 'beta'
                       }
    
    filename = "./billiald_thermopower_diffusion.i"
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
        ##### UPDATE HERE #######
def runMoose():
    run_cmd = "sh ./run_sim_billiald.sh"
    subprocess.call(run_cmd, shell=True)


# Cleans the variable to rturn an array of floats
def clean_var(var):
    temp = re.sub('e', '', var[0])
    mylist = temp.split(',')
    
    res = []
    for i in range(len(mylist)):
        s = mylist[i]
        res.append(re.sub('[\s+]', '', s))
    
    res = [float(i) for i in res]
    return res
    
# Creating file for storing the results
def writeRawDataCSV(DV):
    
    filename = 'T_200.csv'
     
    line = ['id_raw','Alpha','Beta'] + map(str,DV)
    for dv in DV: 
        line.append(str(dv/(1E-9*(230.9))))
    
    with open(filename, 'a+') as csvfile:
        linewriter = csv.writer(csvfile)
        linewriter.writerow(line)  
   
   
   
def toCSV(Alpha, Beta, T_dv):  
    
    line =[Alpha] + [Beta] + T_dv
    
    filename = 'T_200.csv'
    with open(filename, 'a+') as csvfile:  
        wr = csv.writer(csvfile)
        wr.writerow(line)
        
        

# MAIN

# Define the range of values for the simulation

Beta = [2/(2.44*1E-8)] # for testing purposes
#Beta = np.arange(1,2/(2.44*1E-8), 100) # for research mode
#Beta = np.logspace(0,1,100) # for full scan mode

#Alpha = [1] # for testing purposes
#Alpha = np.logspace(-1, 1, 10, endpoint=False) # for full scan mode
Alpha = np.arange(0.1,25, 0.3) # for research mode

#DV = [100*1E-9*(230.9)] # for testing purpose
DV = np.arange(100,1000,100)*1E-9*(230.9) # for the curve

T_fridge = 0.170


# Loop through the simulation and simulate for all possible variations 
for i in range(len(Alpha)):
    
    alpha = Alpha[i]    
    
    for j in range(len(Beta)):

        beta = Beta[j]

        temp_res = []

        for dv in DV:
            
            writeMooseInput(alpha, beta, T_fridge, dv)
                
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
            grid_x, grid_y = np.mgrid[-1.6:2.6:100j, 0:10:100j] # here we manually define the range of the mesh
            grid_T1 = griddata(nodes, val_T, (grid_x, grid_y), method='linear')
            
            t_point = grid_T1[50,80]
            
            temp_res.append(t_point)
            print "Sim done!"
            
        
        # Put temp_res into CSV file
        toCSV(alpha, beta, temp_res)
        print "Added, " + str(temp_res)
        
        

 


