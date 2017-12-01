#!/bin/bash

clear

./thermopower_diffusion-opt -i thermopower_diffusion.i > /dev/null

/opt/moose/seacas/bin/ncdump thermopower_diffusion_out.e > out.txt
