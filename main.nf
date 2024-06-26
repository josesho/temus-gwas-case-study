#!/Users/josesho/bin nextflow

/*
Written by Joses Ho, 22 June 2024.
Configuration is found in the same directory as `nextflow.config`.
*/
nextflow.enable.dsl=2

process qc {
    tag 'quality_control'
    publishDir 'output'//, mode: 'copy', overwrite: false

    input:
    path bed
    path bim
    path fam

    output:
    path "${params.prefix}_qc*.{bed,bim,fam}"

    shell:
    """
    !{params.bashPath} !{projectDir}/bin/qc.sh \
     !{bed} !{bim} !{fam} \
     !{params.mind_cutoff} !{params.geno_cutoff} !{params.maf_cutoff}
    """
}

process splitByEthnicity {
    tag 'split_by_ethnicity'
    publishDir 'output'//, mode: 'copy', overwrite: false

    input:
    path qc_files

    output:
    path "${params.prefix}_qc_*.{txt,bed,bim,fam}"

    shell:
    """
    !{params.bashPath} !{projectDir}/bin/split_by_ethnicity.sh \
        !{params.samples} ${qc_files[0]} ${qc_files[1]} ${qc_files[2]}
    """
}

process gwas {
    tag 'gwas'
    publishDir 'output'//, mode: 'copy', overwrite: false

    input:
    path split_files

    output:
    path "${params.prefix}_qc_gwasResults_ethnicity*.{qassoc,log,nosex}"

    shell:
    """
    !{params.bashPath} !{projectDir}/bin/gwas.sh ${params.prefix} ${split_files[-1]} ${params.phenotypes}
    """
}

process commonVariants {
    tag 'common_variants'
    publishDir 'output'//, mode: 'copy', overwrite: false

    input:
    path gwas_files

    output:
    path "common_variants.csv"

    shell:
    """
    ${params.pythonPath} !{projectDir}/bin/common_variants.py ${params.variantPvalThreshold} ${gwas_files}
    """
}

workflow {
    qc(params.bed, params.bim, params.fam) | collect \
        | splitByEthnicity | collect \
        | gwas | collect \
        | commonVariants
}

workflow.onError {
    println "Error: Pipeline execution stopped with the following message: ${workflow.errorMessage}"
}

workflow.onComplete {
    println "Pipeline completed at: $workflow.complete"
    println "Execution status: ${ workflow.success ? 'OK' : 'failed' }"
}
