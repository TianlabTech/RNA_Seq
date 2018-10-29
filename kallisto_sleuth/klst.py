import subprocess
import os
#Building an index
#check if index exists, if dont exists
#subprocess.Popen("kallisto index -i transcripts.idx transcripts.fasta.gz",shell=True).wait()
#-i *.idx for index file you created
#transcripts.fasta for /home/genomewide/refgenome/hg38/hg38.fa.trans.fa

#Path
cpu="10"
kallisto="/home/disk/fyh/tools/kallisto_linux-v0.44.0/kallisto"
mainPath="/home/disk/fyh/lab_other_work/kallisto_test"
fastqc="/home/disk/fyh/tools/FastQC/fastqc"
trimmomatic="/home/disk/fyh/tools/Trimmomatic-0.38/trimmomatic-0.38.jar"
fastq_phred="/home/disk/fyh/tools/scr/fastq_phred.pl"
fastqc_res="/home/disk/fyh/lab_other_work/kallisto_test/fastqc_res"
kallisto_res="/home/disk/fyh/lab_other_work/kallisto_test/klst_res"
kallisto_idx="/home/disk/fyh/lab_other_work/kallisto_test/klst_index/hg38.idx"

#tree
# ├── data -> ../STAR_test/data/
# ├── fastqc_res
# ├── klst_index
# │   └── hg38.idx
# └── klst_res




#Quantification
os.chdir(mainPath+"/data")
subprocess.Popen("ls > "+mainPath+"/SRRfile.list",shell=True).wait()
with open(mainPath+"/SRRfile.list") as SRRfile:
    for file in SRRfile:
        realfile=file.rstrip()
        if "_1" in realfile:
            SRRName=realfile[:-8]
            read1=SRRName+"_1.fastq"
            read2=SRRName+"_2.fastq"
            subprocess.Popen(fastqc + " " + read1 + " -o " + fastqc_res + " -t " + cpu, shell=True).wait()
            subprocess.Popen(fastqc + " " + read2 + " -o " + fastqc_res + " -t " + cpu, shell=True).wait()
            subprocess.Popen("unzip " + fastqc_res + "/" + SRRName + "_1_fastqc.zip -d " + fastqc_res,
                             shell=True).wait()
            subprocess.Popen("unzip " + fastqc_res + "/" + SRRName + "_2_fastqc.zip -d " + fastqc_res,
                             shell=True).wait()
            subprocess.Popen(fastq_phred + " " + read1 + "> " + mainPath + "/phred.txt", shell=True).wait()
            subprocess.Popen(
                'grep "Per base sequence content" ' + fastqc_res + '/' + SRRName + '_1_fastqc/summary.txt | cut -f 1 > ' + mainPath + '/headcrop.txt',
                shell=True).wait()
            phred, headcrop = "", ""
            with open(mainPath + "/phred.txt") as phredFile:
                phred = phredFile.readlines()[0].rstrip()
            with open(mainPath + "/headcrop.txt") as headcropFile:
                headcrop = headcropFile.readlines()[0].rstrip()
            if headcrop == "FAIL" or headcrop == "WARN":
                subprocess.Popen(
                    "java -jar " + trimmomatic + " PE -phred" + phred + " " + read1 + " " + read2 + " " + read1 + ".map" + " " + read1 + ".unmap" + " " + read2 + ".map" + " " + read2 + ".unmap HEADCROP:12 SLIDINGWINDOW:5:20",
                    shell=True).wait()
            else:
                subprocess.Popen(
                    "java -jar " + trimmomatic + " PE -phred" + phred + " " + read1 + " " + read2 + " " + read1 + ".map" + " " + read1 + ".unmap" + " " + read2 + ".map" + " " + read2 + ".unmap SLIDINGWINDOW:5:20",
                    shell=True).wait()
            # subprocess.Popen("mkdir " + kallisto_res + "/" + SRRName, shell=True).wait()
            subprocess.Popen("kallisto quant -i "+kallisto_idx+" -o "+kallisto_res+"/"+SRRName+" -b 100 -t "+cpu+" "+read1+".map "+read2+".map",shell=True).wait()
            subprocess.Popen("rm -r " + SRRName + "*map " + fastqc_res + "/" + SRRName + "*.fastqc " + fastqc_res + "/" + SRRName + "*.zip " + mainPath + "/" +"*.txt",shell=True).wait()