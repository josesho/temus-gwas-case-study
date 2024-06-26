#!/Users/josesho/miniforge3/bin/python
# Script to identify common variants
# Written by Joses Ho, 23 June 2024.

import argparse, json
import pandas as pd
import numpy as np

def get_unique_ethnicities_count(marker, df):
    return len(df[df.MARKER == marker].ETHNICITY.unique())

def get_marker_data(marker, df, by):
    return "; ".join(sorted(df[df.MARKER == marker][by].astype(str).tolist()))

def main_func():
    parser = argparse.ArgumentParser(description='Identify common variants across GWAS results\
                                                from different ethnicities.')
    parser.add_argument('pval', metavar='pval',
                        type=float,
                        help='The p-value threshold for GWAS association.')
    parser.add_argument('gwas_assoc', metavar='gwas_assoc',
                        type=str, nargs='+',
                        help='Filenames of GWAS results.')

    args = parser.parse_args()

    # Gather all the quantitative association results.
    assoc_results = [f for f in
                    [f.strip("[],") for f in args.gwas_assoc]
                    if f.endswith(".qassoc")
                    ]

    # Loop through the qassoc files
    # and attach phenotype and ethnicity
    # then combine only those results surviving p-value threshold.
    all_ = []

    for filename in assoc_results:
        filename_split = filename.split(".")

        pheno          = filename_split[-2]
        ethnicity      = filename_split[0].split("ethnicity")[1]

        aa = pd.read_csv(filename,
                        sep="\s+", engine="python"
                        )

        aa.loc[:, "PHENO"]     = np.repeat(pheno, len(aa))
        aa.loc[:, "ETHNICITY"] = np.repeat(ethnicity, len(aa))

        all_.append(aa[aa.P < args.pval].copy())

    all_sig_markers = pd.concat(all_, ignore_index=True)

    # Create a proper MARKER field by concatenating chromosome and SNP.
    all_sig_markers.loc[:,"MARKER"] = all_sig_markers.CHR.astype(str)\
                                        + '_' + all_sig_markers.SNP.astype(str)

    # Identify those markers that appear more than once across different ethnicities.
    common_markers_sig_count = all_sig_markers\
                                .groupby("MARKER").size()\
                                .sort_values(ascending=False)

    marks = common_markers_sig_count.index.to_series()

    common_markers_sig_unique_ethnicities = marks.apply(get_unique_ethnicities_count,
                                                        df=all_sig_markers)
    common_markers = common_markers_sig_unique_ethnicities[common_markers_sig_unique_ethnicities > 1]

    out_ = []
    columns_out = ["PHENO", "ETHNICITY", "P"]

    for col in columns_out:
        out_.append(common_markers\
                    .index\
                    .to_series()\
                    .apply(get_marker_data, df=all_sig_markers, by=col))

    out = pd.concat(out_, axis=1, ignore_index=True)

    out.columns = columns_out

    out.to_csv("common_variants.csv")

if __name__ == "__main__":
    main_func()
