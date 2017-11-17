#!/usr/bin/env perl

#####################################################################################
#    opens all files in a directory ending in ".fasta" 
#    translates the DNA sequences to amino acids
#    assumes nucleotides are written as capital letters (A,C,G,T)
#    assumes the files are in codon format- first nucleotide is first codon position
#    assumes files are not interleaved
#    to do.. make it more file type agnostic (e.g. phylip) and add more genetic code types
#
#    usage    perl translate.pl     
#
#####################################################################################

use strict;
use warnings;

my %geneticcode = ();

$geneticcode{"TTT"} = "F"; $geneticcode{"TTC"} = "F"; $geneticcode{"TTA"} = "L";
$geneticcode{"TTG"} = "L"; $geneticcode{"CTT"} = "L"; $geneticcode{"CTC"} = "L"; 
$geneticcode{"CTA"} = "L"; $geneticcode{"CTG"} = "L"; $geneticcode{"ATT"} = "I";
$geneticcode{"ATC"} = "I"; $geneticcode{"ATA"} = "I"; $geneticcode{"ATG"} = "M";
$geneticcode{"GTT"} = "V"; $geneticcode{"GTC"} = "V"; $geneticcode{"GTA"} = "V"; 
$geneticcode{"GTG"} = "V"; $geneticcode{"TCT"} = "S"; $geneticcode{"TCC"} = "S"; 
$geneticcode{"TCA"} = "S"; $geneticcode{"TCG"} = "S"; $geneticcode{"CCT"} = "P";
$geneticcode{"CCC"} = "P"; $geneticcode{"CCA"} = "P"; $geneticcode{"CCG"} = "P";
$geneticcode{"ACT"} = "T"; $geneticcode{"ACC"} = "T"; $geneticcode{"ACA"} = "T"; 
$geneticcode{"ACG"} = "T"; $geneticcode{"GCT"} = "A"; $geneticcode{"GCC"} = "A"; 
$geneticcode{"GCA"} = "A"; $geneticcode{"GCG"} = "A"; $geneticcode{"TAT"} = "Y";
$geneticcode{"TAC"} = "Y"; $geneticcode{"TAA"} = "*"; $geneticcode{"TAG"} = "*";
$geneticcode{"CAT"} = "H"; $geneticcode{"CAC"} = "H"; $geneticcode{"CAA"} = "Q";
$geneticcode{"CAG"} = "Q"; $geneticcode{"AAT"} = "N"; $geneticcode{"AAC"} = "N"; 
$geneticcode{"AAA"} = "K"; $geneticcode{"AAG"} = "K"; $geneticcode{"GAT"} = "D";
$geneticcode{"GAC"} = "D"; $geneticcode{"GAA"} = "E"; $geneticcode{"GAG"} = "E";
$geneticcode{"TGT"} = "C"; $geneticcode{"TGC"} = "C"; $geneticcode{"TGA"} = "*"; 
$geneticcode{"TGG"} = "W"; $geneticcode{"CGT"} = "R"; $geneticcode{"CGC"} = "R"; 
$geneticcode{"CGA"} = "R"; $geneticcode{"CGG"} = "R"; $geneticcode{"AGT"} = "S";
$geneticcode{"AGC"} = "S"; $geneticcode{"AGA"} = "R"; $geneticcode{"AGG"} = "R"; 
$geneticcode{"GGT"} = "G"; $geneticcode{"GGC"} = "G"; $geneticcode{"GGA"} = "G"; 
$geneticcode{"GGG"} = "G";

`ls -l *.fasta >filenames`;
open FH, "<filenames";

while (<FH>){
    if (/(\S+)\.fasta/) {
	my $file = $1;
	open FH2, "<$file.fasta";
	open OUT, ">$file.trans.fasta";
	while (<FH2>) {
		if (/^>\S+/) {
			my $line=$_;
			chomp $line;
			print OUT "$line";
		}
		else {
			my $seq = $_;
			chomp $seq;
			my $len = length $seq;
			my $num = 0;
			my $location = 0;
			while ($location < ($len - 5)) {
		    		$location = $num * 3;
		    		my $codon = substr($seq, $location, 3);
		    		if (exists $geneticcode{$codon}) {
					print OUT "$geneticcode{$codon}";
		    		}
		    		else { print OUT "-"; }
		    		$num++;
			}
		}
	    	print OUT "\n";
	}
	print OUT "\n";
	close FH2;
	close OUT;
    }
}

    
    
    
