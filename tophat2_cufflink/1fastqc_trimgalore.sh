#import data & software
FASTQC=/home/zhangfeng/tools/FastQC/fastqc/fastqc
TRIMGALORE=/home/zhangfeng/tools/TrimGalore-0.4.4/trim_galore
read1=A1.fastq
read2=A2.fastq
OUTPUT=./
#fastqc查看数据质量
$FASTQC $read1 $read2
#trim_galore去接头，该软件先去除低质量的reads，再调用cutadapt去除接头(default:illumina)

#参数信息
#--stringency 5 当reads中的碱基与接头序列重叠个数达到5个时，进行剪切
#--quality 20 设定Phred quality score阈值，默认为20
#--phred33 选择-phred33或者-phred64，表示测序平台使用的Phred quality score
#--fastqc 进行fastqc质量检测
#--paired 双端测序数据
#--illumina 使用软件提供的Illumina接头序列（通配片段）；可以通过--adapter 参数输入adapter序列。也可以不输入，Trim Galore会自动寻找可能性最高的平台对应的adapter。自动搜选的平台三个，也直接显式输入这三种平台，即--illumina、--nextera和--small_rna
#--length 50 当剪切后reads的长度低于50bp时，丢弃该reads
#--e 0.1 允许reads中错误碱基占比 
#--max_n 2 允许reads中最多的N碱基数目
#--trim-n 从3'和5'端剪切N碱基

$TrimGalore --illumina --paired $read1 $read2 -o $OUTPUT

#(Optional)再次运行fastqc查看数据质量
