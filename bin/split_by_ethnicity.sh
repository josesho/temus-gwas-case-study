#!/bin/bash
# Script to split genotype data (that has been QCed) according to ethnicity, using PLINK.
# Written by Joses Ho, 22 June 2024.

# Loads command line arguments.
samples=$1
bed=$2
bim=$3
fam=$4

# Identify unique ethnicities with `sed`
sed 1d $samples    |                     # remove header
    tr -s ' ' '\t' |                     # replace spaces to tabs
    cut -f2        |                     # pull out the ETHNIC_GROUP field
    sort -nu > ${bed%.bed}_unique_ethnicities.txt # sort numerically and write to file.

# Use plink to filter.
while read -r ethnicity
do
    # Use `awk` to create ID lists for each ethnicity.
    awk -v e="${ethnicity}" '{ if ($2==e) {print $1, $1} }' $samples > ethnicity${ethnicity}_IDs.txt

    # and use plink to filter.
    outPrefix=${bed%.bed}_ethnicity$ethnicity

    plink --bfile ${bed%.bed}\
          --keep ethnicity${ethnicity}_IDs.txt\
          --allow-no-sex\
          --make-bed\
          --out ${outPrefix}

done < ${bed%.bed}_unique_ethnicities.txt
