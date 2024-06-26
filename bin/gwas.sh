#!/bin/bash
# GWAS script using PLINK.
# Written by Joses Ho, 23 June 2024.

# Loads command line arguments.
prefix=$1
ethnicities=$2
phenotypes=$3

# Reads in text file with a unique ethnicity on each line,
# Then identifies the relevant bed/bim/bam files
# and performs association.
while read -r ethnicity
do
    inPrefix=${prefix}_qc_ethnicity${ethnicity}
    outPrefix=${prefix}_qc_gwasResults_ethnicity${ethnicity}

    # See https://www.cog-genomics.org/plink/1.9/input#pheno for more options
    plink --bfile ${inPrefix}\
          --pheno ${phenotypes}\
          --assoc\
          --all-pheno\
          --allow-no-sex\
          --out ${outPrefix}

done < $ethnicities
