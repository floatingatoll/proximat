#!/usr/bin/perl

use Geo::Hashing;

$date = $ARGV[0];

my($hash) = new Geo::Hashing (date => $date);
printf("%.6f,%.6f", map { $_ - int $_ } $hash->lat, $hash->lon);
print " ";
$hash->use_30w_rule(1);
printf("%.6f,%.6f\n", map { $_ - int $_ } $hash->lat, $hash->lon);
