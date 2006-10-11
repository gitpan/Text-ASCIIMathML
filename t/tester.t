#!/usr/local/bin/perl5.8.8

use strict;
use warnings;

use Test::More;
use lib '../blib/lib';
use lib 'blib/lib';
use Text::ASCIIMathML;
use lib 't';
use Entities;

@ARGV = <*.math t/*.math> unless @ARGV;

my @lines = <>;
my $lines = join '', grep(! /^\s*\#/, @lines);
my @tests = split /^\?[ \t]*/m, $lines;
shift @tests;

plan tests => 0+@tests;

my @attr = (mathcolor=>"red", displaystyle=>"true", fontfamily=>"serif");
# Do the tests
my $parser = new Text::ASCIIMathML;
$parser->SetAttribute(ForMoz=>1);
TEST:
foreach my $test (@tests) {
    my ($input, $output) = split /\n/, $test, 2;
    $output =~ s/\n *//g;
    $output = MathML::Entities::name2numbered($output);
    $output =~ s/(&\#x)0([\da-f]{4};)/$1$2/ig;
    is ($parser->TextToMathML($input, [title=>$input], \@attr),
	$output, qq("$input"));
}
