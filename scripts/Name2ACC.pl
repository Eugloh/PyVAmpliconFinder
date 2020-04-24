#!/usr/bin/perl -s

##############################################################
##	Name2ACC.pl												##
##	18/06/2019
##	Amplicon sequencing Illumina MiSeq						##
##	Alexis Robitaille : robitaillea@students.iarc.fr		##
##	IARC, LYON												##
##	adaptation 24/04/2020 												##
##	Version 2.0												##
##############################################################

#	This script is used to format the MSA and RT to contains accession number instead of PyV name using Reference_table_Refseq

##################
##	Libraries	##
##################
use strict;
use warnings;
use Cwd;
use Bio::TreeIO;

my $whereiam=getcwd;

my $reference_table=$whereiam."/../raxml/Reference_table_RefSeq.txt";

my $old_tree=$whereiam."/../raxml/References_align_muscle-45857_consensus.nwk";
my $old_align=$whereiam."/../raxml/References_align_muscle.fasta";

my $new_tree=$whereiam."/../raxml/RefSeq_ID_tree_newick.nwk";
my $new_align=$whereiam."/../raxml/RefSeq_ID_align.fasta";

my %hconversion=();

open(F1, $reference_table) or die "$!: $reference_table\n";

while(<F1>)
{
	my $line=$_;
	chomp($line);
	
	my @tab=split("\t",$line);	# AelPyV1	African elephant polyomavirus 1	Betapolyomavirus	NC_022519
	$hconversion{$tab[0]}=$tab[3];	
	#~ print $tab[0]."\t".$tab[3]."\n";
}
		
close(F1);


my @tree=();
my @subtree=();
my $treetmp="";
my $subtreetmp="";
my $subsubtreetmp="";

open(OLDTREE, $old_tree) or die "$!: $old_tree\n";
		
while(<OLDTREE>)
{
	my $line=$_;
	$treetmp=$line;
	#~ chomp($line);
	#~ print $line."\n";
	#~ @tree=split(',',$line);
	#~ foreach my $k (keys %hconversion){
		
	#~ }
}
		
close(OLDTREE);


my @sorted_by_length = sort { length($b) <=> length($a) } keys %hconversion;

foreach my $name (@sorted_by_length){
	$treetmp =~ s/$name/$hconversion{$name}/i;
}
#~ print $treetmp;


open(NEWTREE, ">".$new_tree) or die "$!: $new_tree\n";
print NEWTREE $treetmp;
close(NEWTREE);


my $align="";

#~ my $value="";

#~ print $hconversion{'AmPV3'};
#~ exit;

open(OLDALIGN, $old_align) or die "$!: $old_align\n";
while(<OLDALIGN>)
{
	my $line=$_;
	chomp($line);
	#~ print $line."\n";
	#~ print $line;
	
	my $towrite="";
	
	if($line =~ /^>(\S+)/){
		my $piece=$1;
		#~ print $piece;
		$towrite=">".$hconversion{$piece};
		#~ print $towrite;
		#~ foreach my $name (keys %hconversion){
			#~ if($line=~/$name/){
				#~ $line =~ s/$name/$hconversion{$name}/i;
				#~ print $line;
				#~ last;
			#~ }
		#~ }
	}
	else{
		$towrite=$line;
	}
	#~ if($line !~ /^\s+/){
		#~ print $line."\n";
		#~ my @tab=split('-',$line);
		#~ chomp($tab[0]);
		#~ print $tab[0];
		#~ my $value=$hconversion{$tab[0]};
		#~ print $value."\n";
		#~ foreach my $name (keys %hconversion){
			#~ if($line=~/$name/){
				#~ print $line;
				#~ $line =~ s/$name/$hconversion{$name}/i;
				#~ print $line;
				#~ push
				#~ last;
			#~ }
		#~ }
	#~ }
	
	
	$align.=$towrite."\n";
}
		
close(OLDALIGN);


open(NEWALIGN, ">".$new_align) or die "$!: $new_align\n";
print NEWALIGN $align;
close(NEWALIGN);


