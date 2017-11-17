#!/usr/bin/env perl


##################################################################
#      Ths script will read through atram output files end in ".fasta" and find
#        the last iteration number, make a new file and print
#        out all the contigs from that iteration.
#        new file --> last.fasta   should work for both atram1 and 2
#
#     usage   perl getlastiteration.pl
#
##################################################################

use strict;
use warnings;

`ls -l *.fasta >files`;

open FH, "<files";
while (<FH>) { 
	if (/(\S+).fasta/ && ! /.last.fasta/) {
		my $file=$1;
		my $iteration=0;
		open FH1, "<$file.fasta";
		open OUT, ">$file.last.fasta";
		while (<FH1>) {
			if (/^>(\d+)/) {
				my $iter=$1;
				if ($iter > $iteration) {
					$iteration = $iter;
				}
			}
		}
		close FH1;
		my $flag=0;
		print "the last iteration is $iteration\n";
		open FH2, "<$file.fasta";
		while (<FH2>) {
			if (/\S+/ && ! /^>/) {
				if ($flag ==1 ) { print OUT; }
			}
			if (/^>/) {
				$flag=0;
				if (/^>$iteration/) {
					print OUT; 
					$flag=1;
				}
			}
		}
		close FH2;
	}
}
 
