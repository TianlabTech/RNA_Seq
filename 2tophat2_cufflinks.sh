#上接质控信息
#import data & software
cuffdiff='/home/zhangfeng/disk/project/Cuffdiff/tools/cufflinks-2.2.1.Linux_x86_64/cuffdiff'
cuffmerge='/home/zhangfeng/disk/project/Cuffdiff/tools/cufflinks-2.2.1.Linux_x86_64/cuffmerge'
cufflinks='/home/zhangfeng/disk/project/Cuffdiff/tools/cufflinks-2.2.1.Linux_x86_64/cufflinks'
pc_gtf='/home/zhangfeng/disk/project/data/annotation/mm9.gtf'
human_gtf='/home/genomewide/annotation/hg19/Homo_sapiens.GRCh37.75.chr.gtf'
tophat2='software_path'
#人类基因组信息
mm10_gtf='/home/genomewide/annotation/mm10/Mus_musculus.GRCm38.87.chr.gtf'
mm10_index='/home/genomewide/refgenome/mm10/mm10'
mm10_fa='/home/genomewide/refgenome/mm10/mm10.fa'

#每个样本
read1=Sample1_R1.fastq
read2=Sample1_R2.fastq
#tophat2与基因组map
$tophat2 -p 8 -o $read1\.tophatdir $mm10_index $read1 $read2
#cufflinks根据tophat2比对结果，依托或不依托于参考基因组的GTF注释文件，计算出各个基因的isoform的FPKM值，并给出gtf注释结果
#-p 表示多线程
#-G 提供一个GFF文件，以此来计算isoform的表达。此时，将不会组装新的transcripts， 程序会忽略和reference transcript不兼容的比对结果
#-g 提供GFF文件，以此来指导转录子组装(RABT assembly)。此时，输出结果会包含reference transcripts和novel genes and isforms
#-u | --multi-read-correct 让Cufflinks来做initial estimation步骤，从而更精确衡量比对到genome多个位点的reads
#详细请见http://blog.sina.com.cn/s/blog_751bd9440102v72b.html
$cufflinks -p 8 -u -G $mm10_gtf -o $read1\.cufflinks $read1\.tophatdir/accepted_hits.bam


#对上述生成的多个cufflinks结果做cuffmerge
#Cuffmerge将各个Cufflinks生成的transcripts.gtf文件融合称为一个更加全面的transcripts注释结果文件merged.gtf
GTF=/home/disk/lynn/data/Cindy_RNA_seq/FASTQ_03062018/COMBINED_GTF
ASM=/home/disk/lynn/data/Cindy_RNA_seq/FASTQ_03062018/ASM.txt
#-g | --ref-gtf 将该reference GTF一起融合到最终结果中
#-s | --ref-sequence / 该参数指向基因组DNA序列。如果是一个文件夹，则每个contig则是一个fasta文件；如果是 一个fasta文件，则所有的contigs都需要在里面。Cuffmerge将#使用该ref-sequence来 帮助对transfrags分类，并排除repeats
#最后一个为包含着GTF文件路径的list i.e. assembly_list.txt
$cuffmerge -g $mm10_gtf -s $mm10_fa -p 10  -o $GTF  $ASM

#cuffdiff用于寻找转录子表达的显著性差异
#-L | --lables default: q1,q2,...qN 给每个sample一个样品名或者一个环境条件一个lable
#-u | --multi-read-correct 让Cufflinks来做initial estimation步骤，从而更精确衡量比对到genome多个位点 的reads
$cuffdiff -o $DIF  -p 10 -L KRAS,CONTROL -u $GTF\/merged.gtf $KRAS_1052,$KRAS_1054,$KRAS_1078,$KRAS_1089 $CONTROL_1055,$CONTROL_1061,$CONTROL_1090

