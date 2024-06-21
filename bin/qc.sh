#!/bin/bash
# QC script using PLINK.
# Written by Joses Ho, 22 June 2024.

# Loads command line argument.
# Assumes .bed file is accompanied with .bim and .fam files with same filename.
bed=$1

# See https://www.cog-genomics.org/plink/1.9/filter for more options.
plink \
    --bfile ${bed%.bed} \
    --mind 0.05 \ # The default for removing samples with missing call rates `--mind` is 0.1.
    --geno 0.05 \ # The default for removing SNPs with missing call rates `--geno` is 0.1.
    --maf 0.01 \  # The default for removing SNPs with minor allele frequency below threshold of 0.01.
    --hwe 1e-6 \  # Filters out SNPs with Hardy-Weinberg equilibirum p value below this.
    --make-bed \  # specifies that output will be a PLINK binary file.
    --out qc_genotypes
