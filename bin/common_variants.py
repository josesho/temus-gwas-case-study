#!/Users/josesho/miniforge3/bin/python
# Script to identify common variants
# Written by Joses Ho, 23 June 2024.
#
import argparse, json

parser = argparse.ArgumentParser(description='Identify common variants across GWAS results\
                                              from different ethnicities.')
parser.add_argument('gwas_assoc', metavar='gwas_assoc', type=str, nargs='+',
                    help='The first file output from GWAS.')

args = parser.parse_args()

with open('common_variants.txt', 'w', encoding="utf-8") as f:
    json.dump(args.gwas_assoc, f)

# split_name = args.gwas_assoc.split("_ethnicity")
# prefix = split_name[0]
