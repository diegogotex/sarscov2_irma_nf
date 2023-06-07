<h3>Automatizando a montagem do genoma de SARS-CoV-2 com o IRMA</h3>
=============

Este worflow permite montar o genoma do SARS-CoV-2 a partir de reads em arquivos fastq.

Dependências:<br>
<ul>
<li>Docker</li>
<li>Nextflow</li>
</ul>

```bash
#executando com dataset de teste a partir do github
nextflow run diegogotex/sarscov2_irma_nf -r main --dir '<path_to_fastq_directory>/**{R1_001,R2_001}.fastq.gz'
```