#!/usr/bin/env nextflow

/*
* Parâmetros
*/
//params.dir =  '$projectDir/**{R1_001,R2_001}.fastq.gz'
params.dir =  './**{R1_001,R2_001}.fastq.gz'
params.outdir = "fasta_out"

amostra = Channel
    .fromFilePairs(params.dir)
    //.view(amostra -> "->${amostra[0]}\n${amostra[1][0]}\n${amostra[1][1]}")

//mapeando as reads com o IRMA
process IRMA {
    maxForks 1 //faz com que o processo seja executado para um arquivo por vez
               //se remover ele pegar o máximo de arquivos suportados pelo script
    input:
    tuple val(id), path(fastq) //tupla é a forma de recuperar os valores distintos dentro do array

    output:
    //path "${id}/SARS-CoV-2.fasta" //o ID é o nome da pasta de saída do IRMA
    tuple val(id), path ("$id")
    
    script:
    """
    IRMA CoV ${fastq[0]} ${fastq[1]} $id
    """

}

//renomeando o arquivo fasta e o cabecalho
process RENAME_FASTA {
    publishDir params.outdir, mode:'copy'

    debug true //imprime a saída na tela

    input:
    tuple val(id), path(fasta)

    output:
    path("${fasta}/${id}.fasta")
    //path("${id}.fasta")

    script:
    """
    sed 's/SARS-CoV-2/${id}/' ${fasta}/SARS-CoV-2.fasta > ${fasta}/${id}.fasta
    """

}


process CONCAT {
    publishDir params.outdir, mode:'copy'

    input:
    path fasta

    output:
    path 'samples.fasta'

    script:
    """
    cat $fasta > samples.fasta
    """

}


process PANGO {
    debug true

    publishDir params.outdir, mode:'copy'

    input:
    path 'fasta_all'

    output:
    path "lineage_report.csv"

    script:
    """
    pangolin $fasta_all --outfile lineage_report.csv
    """

}

//
workflow {

    irma_ch = IRMA(amostra)
    rename_ch = RENAME_FASTA(irma_ch)
    //IRMA(amostra)
    //RENAME_FASTA(IRMA.out)
    concat_ch = CONCAT(rename_ch.collect())
    PANGO(concat_ch)
}


