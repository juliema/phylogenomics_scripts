#!/usr/bin/env perl

##################################################################
#      Ths script will read through atram output or any assemblies files end in ".fasta" and find
#        the longest contig, make a new file and print
#        out only the longest contig. This is ideal for UCEs
#        new file --> longest.fasta   
#
#     DOES NOT DEAL WITH INTERLEAVED.
#
#     usage   perl getlongestcontig.pl
#
##################################################################

use strict;
use warnings;

`ls -l *.fasta >files`;

open FH, "<files";
while (<FH>) { 
	if (/(\S+).fasta/ && ! /.longest.fasta/) {
		my $file=$1;
		open FH1, "<$file.fasta";
		open OUT, ">$file.longest.fasta";
		my %contighash=();
		my $contig;
		my $seq;
		while (<FH1>) {
			if (/^>(.*)$/) {
				 $contig=$1;
				 chomp $contig;
			}
			else {
				$seq=$_;
				chomp $seq;
				if (exists $contighash{$contig}) {
					print "Warning this contig name is found more than once $contig\n";
					print "you might not get the right contig printed out\n";
				}	
				else {
					$contighash{$contig}=$seq;
				}
			}
		}
		my $length=0;
		my $len=0;
		my %keep=();
		foreach $contig (keys %contighash) {
			 my $seq = $contighash{$contig};
			 $len= length($seq);
			 #print "$contig\t$len\n";
			 #print "$len and $length\n";
			 if ($len > $length) {
				%keep=();
				$keep{$contig}=$seq;
				#print "$len is > $length keeping $contig\n";
				$length = $len;
			}
		}
		foreach $contig (keys %keep) {
			print OUT ">$contig\n$keep{$contig}\n";
		}
	}
}	
				

