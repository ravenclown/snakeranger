configfile="config.yaml"

rule all:
  input:
rule fetch_FASTQ_from_SRA:
  output:
    temp("reads/{accession}/{accession}_1.fastq"),
    temp("reads/{accession}/{accession}_2.fastq")
  params:
    args = "--split-files --progress --details",
    accession = "{accession}"
  log:
    "reads/{accession}.log"
  conda:
    "env.yml"
  shell:
    'mkdir -p reads/{params.accession} && '
    'fasterq-dump {params.args} {params.accession} -O reads/{params.accession}'

rule cellranger:
  input:
    r1="reads/{accession}/{accession}_1.fastq",
    r2="reads/{accession}/{accession}_2.fastq",
    idx="..."
  output:
  params:
    fastq_path="reads/{accession}"
    args="--nosecondary --id {accession}"
    idx_path="idx/"
  shell:
    "cellranger count {params.args} --fastq {params.fastq_path} --transcriptome {params.idx_path}"

rule umiTools:
  input:
    " "
