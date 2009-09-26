#!/usr/bin/perl

die "Usage: $0 <distance_in_miles> <home_lat,home_long> <suffix,suffix> <prefix,prefix> ..." unless @ARGV >= 4;

use GIS::Distance;

my $gis = GIS::Distance->new();

my($max) = $ARGV[0];

my($home) = $ARGV[1];
$home =~ s/°//g;
my(@home) = split /\s*,\s*/, $home;

my($suf) = $ARGV[2];
$suf =~ s/°//g;
my(@suf) = split /\s*,\s*/, $suf;

for my $afar (@ARGV[3..$#ARGV]) {
    $afar =~ s/°//g;
    my(@afar) = split /\s*,\s*/, $afar;
    $afar[$_] .= $suf[$_] for 0..$#afar;
    my($dist) = $gis->distance(@home => @afar)->miles();
    print "$dist\t".join(',', @afar)."\n" if $dist <= $max;
}
