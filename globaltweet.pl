#!/usr/bin/perl

use strict;
use warnings;

use Net::Twitter;

my $VERSION = 1;

my $nt = Net::Twitter->new(
    username => $ENV{'NT_USERNAME'},
    password => $ENV{'NT_PASSWORD'},
    clientname => $0,
    clientver => $VERSION,
    clienturl => 'http://github.com/floatingatoll/proximat/blob/master/globaltweet.pl',
    source => '',
);

my $date = $ARGV[0];
die "\$today is not a good day" unless $date =~ /\d+-\d+-\d+/;

use Geo::Hashing;

my($hash) = new Geo::Hashing (date => $date);
$hash->use_30w_rule(1);
my($lat) = (($hash->lat)*180)-90;
my($lon) = (($hash->lon)*360)-180;

my $result = eval { $nt->update({ status => sprintf("$date: %.8f,%.8f",$lat,$lon), lat => $lat, long => $lon}) };
use Data::Dumper; die Dumper { result => $result, '$@' => $@ };
