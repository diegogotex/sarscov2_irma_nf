<h3>Automatizando a montagem do genoma de SARS-CoV-2 com o IRMA</h3>

Este worflow permite montar o genoma do SARS-CoV-2 a partir de reads em arquivos fastq.

Dependências:
Docker
Nextflow

#executando com dataset de teste.
nextflow run diegogotex/sarscov2_irma_nf 

#executando com dataset local.
nextflow run diegogotex/sarscov2_irma_nf -r main --dir <diretorio_com_reads>
#as reads podem estar armazenadas diretamente no diretório ou em subdiretórios.