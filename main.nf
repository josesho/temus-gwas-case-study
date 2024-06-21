#!/Users/josesho/bin nextflow
//change to #!/usr/bin/env nextflow before commit

/*
Written by Joses Ho, 22 June 2024.
Configuration is found in the same directory as `nextflow.config`.
*/
nextflow.enable.dsl=2

process qc {
    tag 'quality_control'

    input:
    path bed
    path bim
    path fam

    output:
    path "output/*.{bed,bim,fam}"

    shell:
    """
    bash !{params.fullPath}bin/qc.sh !{bed} !{bim} !{fam}
    """
}

process splitByEthnicity {
    tag 'split_by_ethnicity'

    input:
    val prefix
    path samples

    output:
    path "*"

    script:
    """
    bash ./bin/split_by_ethnicity.sh {samples} "${prefix}_qc.bed"
    """
}

workflow {
    qc(params.bed, params.bim, params.fam)
    //splitByEthnicity(params.prefix, params.samples)
}



/* process gwas {
    tag 'gwas'
    input:
    path genotype_file from split_genotypes
    path phenotypes

    output:
    path "gwas_results_*" into gwas_results

    script:
    """
    bash bin/gwas.sh ${genotype_file} ${phenotypes}
    """
}

process commonVariants {
    tag 'common_variants'
    input:
    path gwas_results.collect()

    output:
    path "common_variants.txt"

    script:
    """
    bash bin/common_variants.sh ${gwas_results}
    """
}

workflow {
    bed = params.bed
    bim = params.bim
    fam = params.fam
    samples = params.samples
    phenotypes = params.phenotypes

    qc(bed, bim, fam) \
        | splitByEthnicity(samples) \
        | gwas(phenotypes) \
        | commonVariants()
}
*/
