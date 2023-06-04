/*
* Parâmetros
*/
params.dir =  './**{R1_001,R2_001}.fastq.gz'

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
    path "${id}/SARS-CoV-2.fasta" //o ID é o nome da pasta de saída do IRMA

    script:
    """
    IRMA CoV ${fastq[0]} ${fastq[1]} ${id}
    """

}


//renomeando o arquivo fasta e o cabecalho
process RENAME_FASTA {

    input:
    path irma_out

    output:
    path "${id}/${id}.fasta"

    script:
    """
    cp ${id}/SARS-CoV-2.fasta ${id}/${id}.fasta

    awk '/^>/{print ">" substr(FILENAME,1,length(FILENAME)-6); next} 1' ${id}/${id}.fasta > ${id}/${id}_final.fasta
    """

}


/*
process PANGO {

collect para esperar os outros processos rodarem antes de executar esse

}
*/


//
workflow {

    irma_ch = IRMA(amostra)
    //rename_ch = RENAME_FASTA(irma_ch)
    //IRMA(amostra)
    //RENAME_FASTA(IRMA.out)

}


