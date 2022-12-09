#!/bin/csh -f

cd /home/hfaroo9/498-pnr/ece498hk-RISCV-V-Extension/sim

#This ENV is used to avoid overriding current script in next vcselab run 
setenv SNPS_VCSELAB_SCRIPT_NO_OVERRIDE  1

/software/Synopsys-2021_x86_64/vcs/R-2020.12-SP1-1/linux64/bin/vcselab $* \
    -o \
    simv \
    -nobanner \

cd -

