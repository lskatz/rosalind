#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;
use Test::More tests=>2;
use Bio::SeqIO;

# I admit I didn't quite have the mental capacity
# to adapt fib() to this problem and so here is a
# good article explaning it.
# https://medium.com/algorithms-for-life/rosalind-walkthrough-rabbits-and-recurrence-relations-4812c0c2ddb3

subtest 'sample data' => sub{
  my $n=5;
  my $k=3;
  
  my $exp = 19;
  my $obs = fib($n, $k);
  is($obs, $exp);
};

subtest 'real data' => sub{
  my $n=36;
  my $k=5;

  my $exp = '3';
  my $obs = fib($n, $k);
  is($obs, $exp);
};

sub fib{
  my($n, $k) = @_;

  if($n == 1){
    return $n;
  }
  elsif($n == 2){
    return $k;
  }

  my $oneGen = fib($n-1, $k);
  my $twoGen = fib($n-2, $k);

  if($n <= 4){
    return $oneGen + $twoGen;
  }

  return $oneGen + $twoGen * $k;
}

