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

my($glo) = $ARGV[3];
$glo =~ s/°//g;
my(@glo) = split /\s*,\s*/, $glo;
$glo[0] = ($glo[0]*180)-90;
$glo[1] = ($glo[1]*360)-180;

for my $afar (@ARGV[4..$#ARGV]) {
    $afar =~ s/°//g;
    my(@afar) = split /\s*,\s*/, $afar;
    $afar[$_] += $suf[$_] for 0..$#afar;
    my($dist) = sprintf '%.1f', $gis->distance(@home => @afar)->miles();
    print "$dist\t".join(',', @afar)."\t$afar\n" if $dist <= $max;
}

my($dist) = sprintf '%.1f', $gis->distance(@home => @glo)->miles();
print "$dist\t".join(',', @glo)."\tglobal\n" if $dist <= $max;
