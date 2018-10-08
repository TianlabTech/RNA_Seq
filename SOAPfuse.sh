#********************************************#
#           1. download everything           #
#********************************************#
# homepage：http://soap.genomics.org.cn/soapfuse.html
# paper：https://genomebiology.biomedcentral.com/articles/10.1186/gb-2013-14-2-r12
# software dir:https://sourceforge.net/projects/soapfuse/files/SOAPfuse_Package/SOAPfuse-v1.27.tar.gz

wget https://sourceforge.net/projects/soapfuse/files/SOAPfuse_Package/SOAPfuse-v1.27.tar.gz
tar -xzf SOAPfuse-v1.27.tar.gz
wget cytoBand.txt.gz
wget hg19.fa
wget HGNC_Gene_Family_dataset
wget Homo_sapiens.GRCh37.75.gtf.gz
wget HumanRef_refseg_symbols_relationship.list
#********************************************#
#           2. buid the database             #
#********************************************#
perl /home/disk/yangjing/training/soapFuse/SOAPfuse-v1.27/source/SOAPfuse-S00-Generate_SOAPfuse_database.pl  \
    -wg /home/genomewide/refgenome/hg19/hg19.fa \
    -gtf /home/disk/yangjing/training/soapFuse/ref/Homo_sapiens.GRCh37.74.gtf.gz  -cbd /home/disk/yangjing/training/soapFuse/ref/cytoBand.txt.gz   -gf /home/disk/yangjing/training/soapFuse/ref/hgnc_complete_set.txt \
    -rft /home/disk/yangjing/training/soapFuse/ref/HumanRef_refseg_symbols_relationship.list \
     -sd /home/disk/yangjing/training/soapFuse/SOAPfuse-v1.27 -dd ./
#********************************************#
#           3. modify the config.txt         #
#********************************************#
#  1 DB = /home/disk/yangjing/training/soapFuse/ref
# 2 PG_pg_dir=/home/disk/yangjing/training/soapFuse/SOAPfuse-v1.27/source/bin
# 3 PD_all_out=/home/disk/yangjing/training/soapFuse/result
# 4 PS_ps.dir=/home/disk/yangjing/training/soapFuse/SOAPfuse-v1.27/source
# 5 PA_all_fq_postfix     =     fq.gz      # (to 'fasta' or 'fastq')

#********************************************#
#           4. make the sample list          #
#********************************************#
### Sample_name	Library_Name	Run	AvgSpotLen
M000216	SRR018259	Solexa-7009	102
M990802	SRR018260	Solexa-7008	102
M980409	SRR018261	Solexa-7007	102
M010403	SRR018265	Solexa-7005	102
501_MEL	SRR018266	Solexa-7013	102
M000921	SRR018267	Solexa-7014	102
K-562-4	SRR018268	Solexa-7015	102
K-562-3	SRR018269	Solexa-7016	102
### eg: save the raw data to OUTPUT_DIR/K-562-3/Solexa-7016/SRR018269.fastq
#********************************************#
#           5. run SOAPfuse                  #
#********************************************#
perl ~/training/soapFuse/SOAPfuse-v1.27/SOAPfuse-RUN.pl -c ~/training/soapFuse/SOAPfuse-v1.27/config/config.txt \
-fd ~/training/soapFuse/demo/demoData \
-l ~/training/soapFuse/demo/demoData/demoSample.list \
-o ~/training/soapFuse/demo/demoResult
