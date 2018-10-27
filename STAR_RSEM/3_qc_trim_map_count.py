#tree
# ├── data
# │   ├── SRR388226_1.fastq
# │   ├── SRR388226_2.fastq
# │   ├── SRR388227_1.fastq
# │   ├── SRR388227_2.fastq
# │   ├── SRR388228_1.fastq
# │   ├── SRR388228_2.fastq
# │   ├── SRR388229_1.fastq
# │   ├── SRR388229_2.fastq
# │   └── SRR.file
# ├── fastqc_res
# ├── RSEM_res
# └── STAR_res
import os
import subprocess
cpu="10"
mainPath="/home/disk/fyh/lab_other_work/STAR_test/"
fastqc="/home/disk/fyh/tools/FastQC/fastqc"
trimmomatic="/home/disk/fyh/tools/Trimmomatic-0.38/trimmomatic-0.38.jar"
STAR="/home/disk/fyh/tools/STAR-2.6.0a/bin/Linux_x86_64_static/STAR"
RSEM="/home/disk/fyh/tools/RSEM-1.3.1/rsem-calculate-expression"
fastq_phred="/home/disk/fyh/tools/scr/fastq_phred.pl"
infer_experiment="/home/disk/fyh/tools/RSeQC-2.6.5/scripts/infer_experiment.py"
strand_test="/home/disk/fyh/tools/scr/strand.sh"
STAR_index="/home/genomewide/RNA-seq_idx/hg38/STAR"
RSEM_index="/home/genomewide/RNA-seq_idx/hg38/RSEM/hg38"
RefSeq="/home/genomewide/RNA-seq_idx/hg38/hg38_RefSeq.bed"
fastqc_res="/home/disk/fyh/lab_other_work/STAR_test/fastqc_res"
STAR_res="/home/disk/fyh/lab_other_work/STAR_test/STAR_res"
RSEM_res="/home/disk/fyh/lab_other_work/STAR_test/RSEM_res"
log_file="/home/disk/fyh/lab_other_work/STAR_test/quantity_log.txt"
os.chdir(mainPath+"data")
subprocess.Popen("ls > ../SRRfile.list",shell=True).wait()
with open(mainPath+"SRRfile.list") as SRRfile:
    for file in SRRfile:
        realfile=file.rstrip()
        if "_1" in realfile:
            SRRName=realfile[:-8]
            read1=SRRName+"_1.fastq"
            read2=SRRName+"_2.fastq"
            subprocess.Popen(fastqc+" "+read1+" -o "+fastqc_res+" -t "+cpu,shell=True).wait()
            subprocess.Popen(fastqc+" "+read2+" -o "+fastqc_res+" -t "+cpu,shell=True).wait()
            subprocess.Popen("unzip "+fastqc_res+"/"+SRRName+"_1_fastqc.zip -d "+fastqc_res,shell=True).wait()
            subprocess.Popen("unzip "+fastqc_res+"/"+SRRName+"_2_fastqc.zip -d "+fastqc_res,shell=True).wait()
            subprocess.Popen(fastq_phred+" "+read1+"> "+mainPath+"phred.txt",shell=True).wait()
            subprocess.Popen('grep "Per base sequence content" '+fastqc_res+'/'+SRRName+'_1_fastqc/summary.txt | cut -f 1 > '+mainPath+'headcrop.txt',shell=True).wait()
            phred,headcrop="",""
            with open(mainPath+"phred.txt") as phredFile:
                phred=phredFile.readlines()[0].rstrip()
            with open(mainPath+"headcrop.txt") as headcropFile:
                headcrop=headcropFile.readlines()[0].rstrip()
            if headcrop=="FAIL" or headcrop=="WARN":
                subprocess.Popen("java -jar "+trimmomatic+" PE -phred"+phred+" "+read1+" "+read2+" "+read1+".map"+" "+read1+".unmap"+" "+read2+".map"+" "+read2+".unmap HEADCROP:12 SLIDINGWINDOW:5:20",shell=True).wait()
            else:
                subprocess.Popen("java -jar "+trimmomatic+" PE -phred"+phred+" "+read1+" "+read2+" "+read1+".map"+" "+read1+".unmap"+" "+read2+".map"+" "+read2+".unmap SLIDINGWINDOW:5:20",shell=True).wait()
            subprocess.Popen("mkdir "+STAR_res+"/"+SRRName,shell=True).wait()
            subprocess.Popen(STAR+" --runThreadN "+cpu+" --twopassMode Basic --outSAMstrandField intronMotif --genomeDir "+STAR_index+" --readFilesIn "+read1+".map "+read2+".map --outFileNamePrefix "+STAR_res+"/"+SRRName+"/ --outSAMtype BAM SortedByCoordinate --quantMode GeneCounts TranscriptomeSAM",shell=True).wait()
            subprocess.Popen(infer_experiment+" -i "+STAR_res+"/"+SRRName+"/Aligned.sortedByCoord.out.bam -r "+RefSeq+" > "+STAR_res+"/"+SRRName+"/strand.txt",shell=True).wait()
            subprocess.Popen("sh "+strand_test+" "+"../"+STAR_res+"/"+SRRName+"/strand.txt > "+mainPath+"strandInfer.txt",shell=True).wait()
            strand=""
            with open(mainPath+"strandInfer.txt") as strandFile:
                strand=strandFile.readlines()[0].rstrip()
            subprocess.Popen(RSEM+" -p "+cpu+" --bam --paired-end --forward-prob "+strand+" "+STAR_res+"/"+SRRName+"/Aligned.toTranscriptome.out.bam "+RSEM_index+" "+RSEM_res+"/"+SRRName,shell=True).wait()
            subprocess.Popen("rm -r "+SRRName+"*map "+fastqc_res+"/"+SRRName+"*.fastqc "+fastqc_res+"/"+SRRName+"*.zip "+RSEM_res+"/"+SRRName+".transcript.bam "+RSEM_res+"/"+SRRName+".stat "+STAR_res+"/"+SRRName,shell=True).wait()
            print("finished!")

        elif "_2" in realfile:
            continue

