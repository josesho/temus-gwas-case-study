#!/Users/josesho/miniforge3/bin/python
# Script to identify common variants
# Written by Joses Ho, 23 June 2024.

import argparse, json
import pandas as pd

parser = argparse.ArgumentParser(description='Identify common variants across GWAS results\
                                              from different ethnicities.')
parser.add_argument('pval', metavar='pval',
                    type=float,
                    help='The p-value threshold for GWAS association.')
parser.add_argument('gwas_assoc', metavar='gwas_assoc',
                    type=str, nargs='+',
                    help='Filenames of GWAS results.')

args = parser.parse_args()

# Gather all the quantitative association results!
assoc_results = [f for f in
                 [f.strip("[],") for f in args.gwas_assoc]
                 if f.endswith(".qassoc")
                ]
# # For debug!
# with open("common_variants.txt", "w", encoding="utf8") as f:
#     json.dump(assoc_results, f)

out_ = []

for filename in assoc_results:
    filename_split = filename.split(".")

    pheno          = filename_split[-2]
    ethnicity      = filename_split[0].split("ethnicity")[1]

    aa = pd.read_csv(
        filename,
        sep="\s+", engine="python"
    )


    aa.loc[:, "PHENO"]     = np.repeat(pheno, len(aa))
    aa.loc[:, "ETHNICITY"] = np.repeat(ethnicity, len(aa))

    out_.append(aa[aa.P < args.pval])

out = pd.concat(out_, ignore_index=True)

out.to_csv("common_variants.txt")
