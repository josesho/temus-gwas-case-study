# GWAS Nextflow Pipeline

This Netxflow pipeline processes genotype data for a GWAS study. It performs quality control, then splits the data by ethnic groups, conducts GWAS, and identifies common variants across ethnicities.

## Requirements

- Nextflow
- PLINK v1.9
- Bash (with `awk` installed)
- Python (at least v3.9), with `pandas` installed

## Setup

1. Install Nextflow:
    ```bash
    curl -s https://get.nextflow.io | bash
    ```
2. Install PLINK:
  - On Linux systems:
      ```bash
      sudo apt-get install plink
      ```
  - On MacOS or Windows
    - Select the appropriate binary from the [PLINK site](https://www.cog-genomics.org/plink/).

3. Install Python and required libraries:
  - Python: https://www.python.org/downloads/
  - `pandas`: https://pandas.pydata.org/getting_started.html
    * This will also install `numpy`.

## Running the Pipeline

1. Prepare your data directory:

    ```
    data/
    ├── 100000_variants_10000_samples_5_chromosomes.bed
    ├── 100000_variants_10000_samples_5_chromosomes.bim
    ├── 100000_variants_10000_samples_5_chromosomes.fam
    ├── 100000_variants_10000_samples_5_chromosomes.vcf
    ├── samples.txt
    ├── rsids_100000_variants_5_chromosomes.tsc
    └── phenotype_10000_samples_100cols*.txt
    ```

2. Execute the pipeline:
    ```bash
    nextflow run main.nf
    ```

3. All output files produced will be found in the output directory:

    ```
    output/
    ├── common_variants.csv
    ├── 100000_variants_10000_samples_5_chromosomes_qc_gwasResults_ethnicity0.Y1.assoc
    ├── ...
    ...
    ```
    All `.qassoc` files are the output of PLINK.

    For the common variant analysis, please see `common_variants.csv`:

    |MARKER|PHENO|ETHNICITY|P
    |------|-----|---------|--
    |1_6032|Y44; Y77; Y78|1; 1; 3|1.822e-05; 7.25e-05; 9.884e-05
    |2_34571|Y17; Y26|0; 2|3.525e-05; 6.056e-05
    |3_47995|Y28; Y68|1; 3|8.05e-05; 9.661e-05

    Each row consists of the following fields:
    - MARKER: The marker in `chr_snp` format.
    - PHENO: A list of phenotypes that have significant assocation at the given marker, seperated by semicolons.
    - ETHNICITIES: The list of ethnicities, corresponding to the phenotypes in PHENO, for which there is significant association at the given MARKER.
    - P: The assocation p-value, again respectively in the same order as PHENO and ETHNICITIES.

## Pipeline Steps

1. **Quality Control**: Removes individuals and SNPs with high missingness using PLINK.
2. **Split by Ethnic Groups**: Splits the genotype data based on the ethnic groups in `samples.txt`.
3. **GWAS**: Conducts GWAS separately for each ethnic group.
4. **Common Variants**: Identifies common variants passing a given p-value threshold across different ethnic groups.

## Customization

You can customize parameters in the `nextflow.config` file as needed.

## Troubleshooting

- Ensure all paths in `params` point to the correct files.
- Check logs in the `work` directory for errors.
