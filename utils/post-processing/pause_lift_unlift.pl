#!/usr/bin/perl -i

use strict;
use warnings;

my $z = 0;

# read stdin and any/all files passed as parameters one line at a time
while (<>) {
	# if we any Z-only moves, sandwich it with pauses
	if (/G1\s+.*Z-?\d+(\.\d+)?/) {
		print "G4 S50 ; pause to avoid step skipping\n" or die $!;
		print or die $!;
		print "G4 S50 ; pause to avoid step skipping\n" or die $!;
	}
	else {
		# nothing interesting, print line as-is
	print or die $!;
	}
}
