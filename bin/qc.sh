#!/bin/bash
# QC script using PLINK.
# Written by Joses Ho, 22 June 2024.

# Loads command line arguments.
bed=$1
bim=$2
fam=$3
MIND_CUTOFF=$4
GENO_CUTOFF=$5
MAF_CUTOFF=$6

# See https://www.cog-genomics.org/plink/1.9/filter for more options.
plink --bfile ${bed%.bed}\
    --mind $MIND_CUTOFF\
    --geno $GENO_CUTOFF\
    --maf $MAF_CUTOFF\
    --allow-no-sex\
    --make-bed\
    --out ${bed%.bed}_qc
