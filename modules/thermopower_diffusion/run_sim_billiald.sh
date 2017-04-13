#!/bin/bash

clear

./thermopower_diffusion-opt -i billiald_thermopower_diffusion.i

/opt/moose/seacas/bin/ncdump billiald_thermopower_diffusion_out.e > out.txt
                                                         
rm billiald_thermopower_diffusion_out.e-*