# -*- coding: utf-8 -*-
# P.Thulstrup 03/13/2017
#


# LIBRARIES
import os
import re
import numpy as np
import subprocess
import csv
import os.path
import sys


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
 
# Cretes the filename in which we will 
def createFilename(Alpha, Beta, Exponent):
    location = "./data/T_" + str(Exponent)
    
    if len(Alpha)>1:
        alpha_txt = "_alpha-" + str(min(Alpha)) + "-" + str(max(Alpha)) + "-step" + str(Alpha[1]-Alpha[0]) 
    else:
        alpha_txt = "_alpha-" + str(Alpha[0])
        
    if len(Beta)>1:
        beta_txt = "_beta-" + str(min(Beta)) + "-" + str(max(Beta))
    else:
        beta_txt = "_beta-" + str(Beta[0])  
      
    filename = location + alpha_txt + beta_txt + ".csv"
    
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
    

         
#Write in the csv file, here T_dv must be a list of array that ranges on 
def toCSV(filename, Alpha, Beta, T_dv):  
    
    line =[Alpha] + [Beta] + T_dv

    with open(filename, 'a+') as csvfile:  
        wr = csv.writer(csvfile)
        wr.writerow(line)
        
        

# MAIN

Exponent = 3
to_csv = False
T_fridge = 0.170
#DV = np.arange(100,1000,100)*1E-9*(230.9)
DV = [1000*1E-9*(230.9)] # for testing purpose


# Define the range of values for the simulation
Beta = [2/(2.44*1E-8)] # for testing purposes
#Beta = np.arange(1,2/(2.44*1E-8), 100) # for research mode
#Beta = np.logspace(0,10,100) # for full scan mode

#Alpha = [1] # for testing purposes
Alpha = np.logspace(-1, 1, 100, endpoint=False) # for full scan mode
#Alpha = np.arange(2,30, 5) # for research mode


# Here create the filename and verify it does not exist
filename = createFilename(Alpha, Beta, Exponent)
print "\n"

# Loop through the simulation and simulate for all possible variations 
for alpha in Alpha:            
    
    for beta in Beta:
        
        temp_res = []
        print "Simulating:"
        print " - Alpha = " + str(alpha)
        print " - Beta = " + str(beta)
        
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
            
        
        # Put temp_res into CSV file
        if to_csv:
            toCSV(filename, alpha, beta, temp_res)
            print "Added, " + str(temp_res)
            
        print "\n"

