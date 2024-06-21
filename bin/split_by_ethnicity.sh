#!/bin/bash
# Script to split genotype data (that has been QCed) according to ethnicity, using PLINK.
# Written by Joses Ho, 22 June 2024.

samples=$1
bed=$2


# Split genotypes by ethnic groups
sed 1d $samples    |                     # remove header
    tr -s ' ' '\t' |                     # replace spaces to tabs
    cut -f2        |                     # pull out the ETHNIC_GROUP field
    sort -nu > ../output/${bed%.bed}_unique_ethinicities.txt # sort numerically and write to file.

while read -r line
do
  # echo "$line" ## For debugging.
  prefix=$(${bed%.bed}_ethnicity$line)
  plink --bfile ${bed%.bed} --keep $line --make-bed --out ../output/$prefix
done < ${bed%.bed}_unique_ethinicities.txt
