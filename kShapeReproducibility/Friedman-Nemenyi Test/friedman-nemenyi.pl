#!/usr/bin/perl -w

use strict;
use warnings;

use FileHandle;
use Data::Dumper;
use Statistics::Distributions;

my $fh = new FileHandle;



my $file;




$file = shift;


if (!defined($file)){
   print "USAGE: friedman-nemenyi.pl <datafile>\n";
   exit(0);
}


$fh->open("< $file") or die "Could not open $file";

my $line;

$line = $fh->getline();

chomp($line);

$line =~ s/^\s+//g;

my (@algs, $alg); 

@algs = split(/\s+/, $line);

my ($ds, @res, %results,@dsorder);

while($line = $fh->getline() or not eof($fh)){
  chomp $line;
  if (length($line)>3){
  ($ds, @res) = split(/\s+/, $line);
  push (@dsorder,$ds);
  foreach $alg (@algs){
    $results{$ds}{$alg}{res} = shift @res;
  }
  
  my $rank_pos = 1;
  my $rank_value = 2;
  my @draw;
  my $i;
  my $rank_draw;
  my $mean_rank;

  foreach $alg (sort {$results{$ds}{$b}{res} <=> $results{$ds}{$a}{res}} keys %{$results{$ds}}){
  if ($results{$ds}{$alg}{res} < $rank_value){
    if (scalar(@draw) > 1){
      $mean_rank = ($rank_pos + $rank_draw -1)/2;
      foreach $i (@draw){
        $results{$ds}{$i}{rank} = $mean_rank;
      }
      undef(@draw);
    }
    $rank_value = abs($results{$ds}{$alg}{res});
    $results{$ds}{$alg}{rank} = $rank_pos;
    @draw = ($alg);
    $rank_draw = $rank_pos;
  }elsif($results{$ds}{$alg}{res} == $rank_value){
    push (@draw, $alg);
  }else{
    die "**************************$rank_value, ";
  }
    $rank_pos++;
  }
  
  if (scalar(@draw) > 1){
    $mean_rank = ($rank_pos + $rank_draw -1)/2;
    foreach $i (@draw){
      $results{$ds}{$i}{rank} = $mean_rank;
    }
    undef(@draw);
  }
  }

}

my %avg;

foreach $alg (@algs){
  foreach $ds (keys %results){
    $avg{$alg} += $results{$ds}{$alg}{rank};
  }
}

my ($N, $k);
$N = scalar keys %results;
$k = scalar @algs;
my ($sum_R, $X_sq);

foreach $alg (@algs){
  $avg{$alg}/=$N;
  $sum_R+=$avg{$alg}**2;
}


$X_sq = ((12*$N)/($k*($k+1)))*($sum_R - (($k*($k+1)**2))/4);


my $chi = Statistics::Distributions::chisqrdistr($k-1,.05); 

printf "%20s\t","";
foreach $alg (@algs){
  printf ("%s\t\t",$alg);
}
printf "\n\n";

foreach $ds (@dsorder){
  printf "%20s\t",$ds;
  foreach $alg (@algs){
    printf ("%.3f(%.1f)\t",$results{$ds}{$alg}{res},$results{$ds}{$alg}{rank});
  }
  printf "\n";
}

printf "\n%20s\t","average rank";
foreach $alg (@algs){
  printf ("%.3f\t\t",$avg{$alg});
}
printf "\n\n";


printf "The Chi-Square statistics is %.2f.\n",$X_sq;
printf "The critical value of the Chi\-square statistics with %d degrees of freedom and at 95 percentile is %.2f\n", $k-1, $chi;
if ($X_sq >= $chi){
  print "According to the Freidman test using the Chi-Square statistics, the null-hypothesis that all algorithms behave similar should be rejected\n\n";
}else{
  print "According to the Freidman test using the Chi-Square statistics, the null-hypothesis that all algorithms behave similar should not be rejected\n\n";
}

$chi = Statistics::Distributions::chisqrdistr($k-1,.1);

printf "The critical value of the Chi\-square statistics with %d degrees of freedom and at 90 percentile is %.2f\n", $k-1, $chi;
if ($X_sq >= $chi){
  print "According to the Freidman test using the Chi-Square statistics, the null-hypothesis that all algorithms behave similar should be rejected\n\n";
}else{
  print "According to the Freidman test using the Chi-Square statistics, the null-hypothesis that all algorithms behave similar should not be rejected\n\n" }
    

my $F = (($N-1)*$X_sq)/($N*($k-1)-$X_sq);

my $ff = Statistics::Distributions::fdistr($k-1,($k-1)*($N-1),.05);

printf "The F-statistics is %.2f.\n",$F;

printf "The critical value of the F-statistics with %d and %d degrees of freedom and at 95 percentile is %.2f\n", $k-1, ($N-1)*($k-1), $ff;
if ($F >= $ff){
  print "According to the Freidman test using the F-statistics, the null-hypothesis that all algorithms behave similar should be rejected\n\n";
}else{
  print "According to the Freidman test using the F-statistics, the null-hypothesis that all algorithms behave similar should not be rejected\n\n";  
}

$ff = Statistics::Distributions::fdistr($k-1,($k-1)*($N-1),.1);

printf "The critical value of the F-statistics with %d and %d degrees of freedom and at 90 percentile is %.2f\n", $k-1, ($N-1)*($k-1), $ff;
if ($F >= $ff){
  print "According to the Freidman test using the F-statistics, the null-hypothesis that all algorithms behave similar should be rejected\n\n";
}else{
  print "According to the Freidman test using the F-statistics, the null-hypothesis that all algorithms behave similar should not be rejected\n\n";
}

print "Running the Nemenyi post-hoc test to verify wheter it is possible to detect differences among algorithms.\n\n";

my $qa = {
2 => 1.960,
3 => 2.343,
4 => 2.569,
5 => 2.728,
6 => 2.850,
7 => 2.949,
8 => 3.031,
9 => 3.102,
10 => 3.164,
11 => 3.2186,
12 => 3.2680,
13 => 3.3127,
14 => 3.3536,
15 => 3.3912,
16 => 3.4260,
17 => 3.4584,
18 => 3.4887,
19 => 3.5171,
20 => 3.5438
};

my $CD = $qa->{$k}*sqrt(($k*($k+1))/(6*$N));

printf "According to the the Nemenyi statistis, the critical value for comparing the mean-ranking of two different algorithms at 95 percentile is %.2f. Mean-rankings differences above this value are significative.\n\n",$CD;

printf "Algorithms which performed better are marked as +++, worst as ---, and where it is not possible to detect difference is marked as ooo.\n\n";

my @order_algs =  sort {$avg{$a} <=> $avg{$b}} keys %avg;
my @order_rank =  sort {$a <=> $b} values %avg;

my ($i,$j);


printf "%20s %s\n", "",join "\t", @order_algs;

for $i (0..scalar(@order_algs)-1){
  printf "%20s\t[", $order_algs[$i];
  for $j (0.. scalar(@order_algs)-1){
    if ($order_rank[$i] - $order_rank[$j] >= $CD){
      print "---\t";
    }elsif ($order_rank[$j] - $order_rank[$i] >= $CD){
      print "+++\t";
    }else{
      print "ooo\t";
    }
  }
  print "]\n";
}

$qa = {
2 => 1.645,
3 => 2.052,
4 => 2.291,
5 => 2.459,
6 => 2.589,
7 => 2.693,
8 => 2.780,
9 => 2.855,
10 => 2.920,
11 => 2.9777,
12 => 3.0297,
13 => 3.0767,
14 => 3.1197,
15 => 3.1592,
16 => 3.1957,
17 => 3.2297,
18 => 3.2614,
19 => 3.2912,
20 => 3.3192
};

$CD = $qa->{$k}*sqrt(($k*($k+1))/(6*$N));

printf "\nAccording to the the Nemenyi statistis, the critical value for comparing the mean-ranking of two different algorithms at 90 percentile is %.2f. Mean-rankings differences above this value are significative.\n\n",$CD;

printf "Algorithms which performed better are marked as +++, worst as ---, and where it is not possible to detect difference is marked as ooo\n\n";

@order_algs =  sort {$avg{$a} <=> $avg{$b}} keys %avg;
@order_rank =  sort {$a <=> $b} values %avg;

printf "%20s %s\n", "",join "\t", @order_algs;

for $i (0..scalar(@order_algs)-1){
  printf "%20s\t[", $order_algs[$i];
  for $j (0.. scalar(@order_algs)-1){
    if ($order_rank[$i] - $order_rank[$j] >= $CD){
      print "---\t";
    }elsif ($order_rank[$j] - $order_rank[$i] >= $CD){
      print "+++\t";
    }else{
      print "ooo\t";
    }
  }
  print "]\n";
}


