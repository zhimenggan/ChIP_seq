#!/bin/bash

module load bedtools
module load samtools

##sort the first bam file, if needed
	bam_1_sorted=${bam_1%.*}.sorted
		if [ ! -f ${bam_1_sorted}.bam ]
		then
		samtools sort -T bam1 -o ${bam_1_sorted}.bam $bam_1 #updated to v1.3
		samtools index ${bam_1_sorted}.bam
		fi
	bam_1_sorted=${bam_1_sorted}.bam

##sort the second bam file, if needed
	bam_2_sorted=${bam_2%.*}.sorted
		if [ ! -f ${bam_2_sorted}.bam ]
		then
		samtools sort -T bam2 -o ${bam_2_sorted}.bam $bam_2 #updated to v1.3
		samtools index ${bam_2_sorted}.bam
		fi
	bam_2_sorted=${bam_2_sorted}.bam
	
out_file_count=${out_file}.raw.bed
out_file_RPM=${out_file}.cov.RPM.bed

bedtools multicov -bams $bam_1_sorted $bam_2_sorted -bed $bed_file > $out_file_count

total_reads1=`samtools view -bh -L ${bed_file} ${bam_1} |samtools flagstat - |head -1|sed -e 's/\s/\\t/g' |cut -f 1`
total_reads2=`samtools view -bh -L ${bed_file} ${bam_2} |samtools flagstat - |head -1|sed -e 's/\s/\\t/g' |cut -f 1`

#this next part only works on 3 column initial bed files.
awk -F "\t" -v total_reads1="$total_reads1" -v total_reads2="$total_reads2" 'BEGIN{OFS="\t"}{print $1,$2,$3,$4*1000000/total_reads1,$5*1000000/total_reads2}' $out_file_count > $out_file_RPM


chgrp khanlab $bam_1_sorted
chgrp khanlab $bam_2_sorted
chgrp khanlab $bed_file
chgrp khanlab $out_file_count
chgrp khanlab $out_file_RPM
