#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;
use Test::More tests=>2;
use Bio::SeqIO;

subtest 'sample data' => sub{
  my $input = "GATATATGCATATACTT
ATAT";
  my $exp = "2 4 10";
  my $obs = motifPositions($input);
  is($obs, $exp, $input);
};

subtest 'real data' => sub{
  local $/=undef;
  my $input = <DATA>;
  my $exp = "39 46 103 110 169 210 225 279 286 304 311 335 342 357 407 414 482 538 574 581 652 661 720 727 804 811 831 899 952";
  my $obs = motifPositions($input);
  is($obs, $exp, $input);
};

sub motifPositions{
  my($input) = @_;
  
  my($dna,$motif) = split(/\n/, $input);

  my $positions = "";
  my $pos = 0;
  while((my $nextPos = index($dna, $motif, $pos)) > -1){
    $nextPos++; # 1-based
    $positions .= "$nextPos ";
    $pos = $nextPos;
  }
  $positions =~ s/\s+$//;
  return $positions;
}

__DATA__
GTCGTGGCTAGAGGACGCGTGGCTGTACGTGGCTTTTCCGTGGCTCGTGGCTCGTGGCTGGCATCCGTGGCTTCGTGGCTAGCCGTGGCTTCGTGGCTGGCACGTGGCTCGTGGCTCGTGGCTCTTAGGCGTGGCTTCGTGGCTACCCGCGTGGCTTTCCGTGGCTGCCGTGGCTCGTGGCTATTCGTGGCTCAACTACCGTGGCTTGCCGTGGCTCGTGGCTGCGTGGCTCGTGGCTTCCAGTGTTGGTGACGTGGCTATCGTGGCTCTCGTGGCTACGTGGCTCGTGGCTCGTGGCTTTCACGTGGCTCGTGGCTCGTGGCTGGCGTGGCTACGTGGCTCGTGGCTCGTGGCTCCGTGGCTCGTGGCTTCGTGGCTTGCTGGCCGTGGCTGTCGTGGCTCCGATCGTGGCTCGTGGCTCGTGGCTAGACGCCCGTGGCTCTTGACGTGGCTAACGTGGCTGCCGTGGCTGCCGTGGCTGCGTGGCTCGTGGCTTAGCGTGGCTTGCTCGTGGCTATCCGTGGCTCCGTGGCTGTCCGTGGCTCGTGGCTGCGTGGCTCCCCCACGTGGCTCCGTGGCTCGTGGCTCGCCGTGGCTCCCGTGGCTGTTATCGTGGCTGCTGACCGTGGCTAACGTGGCTCTGCTATATCGCGTGGCTCGCGTGGCTCGTGGCTACCGTGGCTTCAACGTGGCTGAGTTCGTGGCTGTGCACGTGGCTACGTGGCTCGTGGCTCGTGGCTGCTGATTTACAGCGTGGCTAACGTGGCTTAAAAAATATTGCGTGGCTATCGTGGCTGCCGTTCCGTGGCTCGTGGCTCGTGGCTTGTCTACGTGGCTCGTGGCTACCTATCGTGGCTACGTGGCTCCCGTGGCTTGTCGTGGCTTGACGACGTGGCTGCGTGGCTCGTGGCTGTACCGTGGCTTGCGTGGCTGCGTGGCTGCGTGGCTTCACGTGGCTCGTGGCTGCGTGGCT
CGTGGCTCG