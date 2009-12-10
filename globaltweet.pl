#!/usr/bin/perl

my $outlink = '';
# would prefer to use drwilco globalmap but it doesn't show the marker when linked
# http://www.drwilco.net/globalhash/map.html?date=YYYY-MM-DD
# tried to use xkcd wiki but there's no globalhash-of-the-day template to link to
# http://wiki.xkcd.com/geohashing/YYYY-MM-DD_global';

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

if (length($outlink) > 0) {
    $outlink =~ s/YYYY-MM-DD/$date/g;
    $outlink = ' '.$outlink;
}

my $message = sprintf("$date: %.8f,%.8f$outlink",$lat,$lon);
if ($ENV{'NT_DEBUG'}) {
    die $message;
}
my $result = eval { $nt->update({ status => $message, lat => $lat, long => $lon}) };
use Data::Dumper; die Dumper { result => $result, '$@' => $@ } if $@ or not defined $result;
