# GWAS Nextflow Pipeline

This Netxflow pipeline processes genotype data for a GWAS study. It performs quality control, then splits the data by ethnic groups, conducts GWAS, and identifies common variants.

## Requirements



- Nextflow
- PLINK
- Bash

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
    Select the appropriate binary from the [PLINK site](https://www.cog-genomics.org/plink/).

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

## Pipeline Steps

1. **Quality Control**: Removes individuals and SNPs with high missingness using PLINK.
2. **Split by Ethnic Groups**: Splits the genotype data based on the ethnic groups in `samples.txt`.
3. **GWAS**: Conducts GWAS separately for each ethnic group.
4. **Common Variants**: Identifies common variants across different ethnic groups.

## Customization

You can customize parameters in the `nextflow.config` file as needed.

## Troubleshooting

- Ensure all paths in `params` point to the correct files.
- Check logs in the `work` directory for errors.
