#!/usr/bin/perl

my $outlink = 'http://www.geonames.org/maps/showOnMap?q=LAT,LON';
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
    $outlink =~ s/LAT/$lat/g;
    $outlink =~ s/LON/$lon/g;
}

use WWW::Shorten::Bitly;
$outlink = eval { $outlink = makeashorterlink($outlink, $ENV{'BITLY_USERNAME'}, $ENV{'BITLY_API_KEY'}) } || '';

if (length($outlink) > 0) {
    $outlink = ' @ '.$outlink;
}

use Geo::Geonames;
my $geo = eval { new Geo::GeoNames() };
my $geores = eval { $geo->find_nearby_placename(lat => $lat, lng => $lon, radius => 300, maxRows => 1, style => 'FULL')->[0] };

my $message = sprintf("$date: %.8f,%.8f$outlink",$lat,$lon);

goto NO_MORE unless eval { $geores->{countryCode} };

my $cc = sprintf('near %s', $geores->{countryCode});

if (length("$message $cc") > 140) {
    goto NO_MORE;
}

my $an = '';
my @an = reverse grep { defined $_ && not ref $_ } @{$geores}{qw( name adminName2 adminName1 countryName )};

for (0..$#an) {
    my $test = join ', ', @an[0..$_];
    if (length("$message near $test") > 140) {
        last;
    }
    $an = $_;
}

if ($an) {
    $message = "$message near " . join(', ', reverse @an[0..$an]);
} else {
    $message = "$message $cc";
    goto NO_MORE;
}

NO_MORE:

if ($ENV{'NT_DEBUG'}) {
    die $message;
}
my $result = eval { $nt->update({ status => $message, lat => $lat, long => $lon}) };
use Data::Dumper; die Dumper { result => $result, '$@' => $@ } if $@ or not defined $result;
