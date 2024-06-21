#!/bin/bash
# QC script using PLINK.
# Written by Joses Ho, 22 June 2024.

# Loads command line arguments.
bed=$1
bim=$2
fam=$3

# Assigns all options.
MIND_CUTOFF=0.05 # Removing samples with missing call rates `--mind`, default 0.1.
GENO_CUTOFF=0.05 # Removing SNPs with missing call rates, default 0.1.
MAF_CUTOFF=0.05  # Removing SNPs with minor allele frequency below threshold, default 0.01.

# See https://www.cog-genomics.org/plink/1.9/filter for more options.
plink --bfile ${bed%.bed}\
    --mind $MIND_CUTOFF\
    --geno $GENO_CUTOFF\
    --maf $MAF_CUTOFF\
    --allow-no-sex\
    --make-bed\
    --out ${bed%.bed}_qc
