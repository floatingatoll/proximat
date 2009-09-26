#!/usr/bin/perl

die "Usage: $0 <distance_in_miles> <home_lat,home_long> <afar_lat1,afar_long1> ..." unless @ARGV >= 3;

use GIS::Distance;

my $gis = GIS::Distance->new();

my($max) = $ARGV[0];
my($home) = $ARGV[1];
$home =~ s/°//g;
my(@home) = split /\s*,\s*/, $home;
for my $afar (@ARGV[2..$#ARGV]) {
    $afar =~ s/°//g;
    my(@afar) = split /\s*,\s*/, $afar;
    my($dist) = $gis->distance(@home => @afar)->miles();
    print "$dist\t$afar\n" if $dist <= $max;
}
