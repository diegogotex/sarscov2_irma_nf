/*
* Parâmetros
*/

Channel
    .fromFilePairs('./**{R1_001,R2_001}.fastq.gz')
    .view(amostra -> "${amostra[0]}")
//