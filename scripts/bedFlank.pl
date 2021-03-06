#!/usr/bin/perl -w
use strict;
use Getopt::Long;

my $input_file;
my $output_file;
my $flank_length=1000;
my %chr_lengths = (
            'chr1' => 249250621,
            'chr2' => 243199373,
            'chr3' => 198022430,
            'chr4' => 191154276,
            'chr5' => 180915260,
            'chr6' => 171115067,
            'chr7' => 159138663,
            'chrX' => 155270560,
            'chr8' => 146364022,
            'chr9' => 141213431,
            'chr10' => 135534747,
            'chr11' => 135006516,
            'chr12' => 133851895,
            'chr13' => 115169878,
            'chr14' => 107349540,
            'chr15' => 102531392,
            'chr16' => 90354753,
            'chr17' => 81195210,
            'chr18' => 78077248,
            'chr20' => 63025520,
            'chrY' => 59373566,
            'chr19' => 59128983,
            'chr22' => 51304566,
            'chr21' => 48129895
         );

my $usage = <<__EOUSAGE__;

Usage:

Required options:
  -i       <string>    the input bed file
  -f       <integer>   the flank length (default: $flank_length)
  -o       <string>    the output file
  
__EOUSAGE__

GetOptions (
  'i=s' => \$input_file,
  'f=i' => \$flank_length,
  'o=s' => \$output_file,
);

unless ($input_file && $output_file) {
    die $usage;
}


open(BEDOUT, ">$output_file") or die("Failed to open output file");
open(BEDIN, $input_file) or die "Failed to open input file";

while (<BEDIN>) {	
	chomp;
	my @fields = split("\t");
        my $chr = $fields[0];
        my $chr_length = $chr_lengths{$chr};
        next unless ($chr_length);
        my $mid_point = $fields[1] + int(($fields[2] - $fields[1])/2);
        $fields[1] = $mid_point - $flank_length;
        $fields[2] = $mid_point + $flank_length;
        #$fields[2] = $chr_length if ($fields[2] > $chr_length);
        $fields[1] = 0 if ($fields[1] < 0);        
        print BEDOUT join("\t", @fields)."\n";        
};


