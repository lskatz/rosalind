#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;
use Test::More tests=>1;
use Bio::SeqIO;

subtest 'sample data' => sub{
  my $input   = '>Rosalind_1
                ATCCAGCT
                >Rosalind_2
                GGGCAACT
                >Rosalind_3
                ATGGATCT
                >Rosalind_4
                AAGCAACC
                >Rosalind_5
                TTGGAACT
                >Rosalind_6
                ATGCCATT
                >Rosalind_7
                ATGGCACT';
  my $expConsensus  = 'ATGCAACT';
  my $expProfile    = 'A: 5 1 0 0 5 5 0 0
C: 0 0 1 4 2 0 6 1
G: 1 1 6 3 0 1 0 0
T: 1 5 0 0 0 1 1 6
';
  
  my $profile = makeProfile($input);
  is($profile, $expProfile, "profile");
  
  # Get the array version of the profile this time which is
  # invoked with setting it equal to an array instead of a
  # scalar.
  my @profile  = makeProfile($input);
  my $consensus= makeConsensus(\@profile);
  is($consensus, $expConsensus, "consensus");
};

=cut
subtest 'real data' => sub{
  local $/ = undef;
  my $input = <DATA>;
  my $expProfile = '?';
  my $expConsensus='?';

  my $profile = makeProfile($input);
  is($profile, $expProfile, "profile");
};
=cut

sub makeProfile{
  my($input) = @_;

  # clean the whitespace for the input
  $input =~ s/^\s+|\s+$//gm;
  
  # an array of counts for each nt
  # e.g., $profile[0] = {A=>3, T=>4, ...}
  my @profile;

  my $in = Bio::SeqIO->new(-string=>$input, -format=>"fasta");
  while(my $seq = $in->next_seq){
    # Get the sequence of this entry
    my $sequence = $seq->seq;

    # Count the nts along this sequence and add onto
    # the overall profile.
    for(my $i=0; $i<length($sequence); $i++){
      my $nt = substr($sequence,$i,1);
      $profile[$i]{$nt}++;
    }
  }

  # Generate the string profile from the array
  # The profile is in order of ACGT and so we have
  # to do that order too
  my $profileStr;
  for my $nt(qw(A C G T)){
    $profileStr .= "$nt: ";
    for(my $i=0; $i<@profile; $i++){
      my $count = $profile[$i]{$nt} || 0;
      $profileStr .= "$count ";
    }
    $profileStr =~ s/\s+$//; # right whitespace trim
    $profileStr .= "\n";
  }
  
  # If we want more than a string, return the array
  # version of the profile. Otherwise, return the string.
  if(wantarray){
    return @profile;
  }
  return $profileStr;
}

sub makeConsensus{
  my($profile) = @_;

  my $consensus = "";

  for(my $pos=0; $pos<@$profile; $pos++){
    
    # Which nt has the highest count?
    # Start with a low count and a non-nucleotide character
    my $highest   = 0;
    my $highestNt = 'x';
    while(my($nt,$count) = each(%{ $$profile[$pos] })){
      # If this count is more than our highest,
      # record the new count and nt.
      if($highest < $count){
        $highest   = $count;
        $highestNt = $nt;
      }
    }
    $consensus .= $highestNt;
  }
  return $consensus;
}

