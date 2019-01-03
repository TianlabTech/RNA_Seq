perl get_iso.pl /local/pengying/data/anno/Homo_sapiens.GRCh38.87.chr.gtf

time STAR \
--runThreadN 35 \
--runMode genomeGenerate \
--genomeDir /local/pengying/data/anno/STAR \ #索引文件输出位置
--genomeFastaFiles /local/pengying/data/anno/hg38.fa \
--sjdbGTFfile /local/pengying/data/anno/Homo_sapiens.GRCh38.87.chr.gtf \ #注意版本对应
--sjdbOverhang 100 #理论取最大read长度-1，但是100效果也可以


time /local/pengying/tools/RSEM-1.3.1/rsem-prepare-reference \
--gtf /local/pengying/data/anno/Homo_sapiens.GRCh38.87.chr.gtf \
--transcript-to-gene-map /local/pengying/data/anno/knownIsoforms.txt \
--star \
--star-path /local/pengying/tools/STAR-2.6.0a/bin/Linux_x86_64 \
-p 35 \
/local/pengying/data/anno/hg38.fa \
/local/pengying/data/anno/RSEM/hg10
