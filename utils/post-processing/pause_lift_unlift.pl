#!/usr/bin/perl -i

use strict;
use warnings;

my $new_z = 0;
my $cur_z = 0;

# read stdin and any/all files passed as parameters one line at a time
while (<>) {
	if (/G1\s+.*Z-?\d+(\.\d+)?/) {
		$new_z = $1;
	}
	# if we any Z-only moves, sandwich it with pauses
	if (/G1\s+.*Z-?\d+(\.\d+)?/ && !/X/ && !/Y/) {
		if ($new_z != $cur_z) {
			print "G4 S50 ; pause to avoid step skipping\n" or die $!;
			print or die $!;
			print "G4 S50 ; pause to avoid step skipping\n" or die $!;
		}
		else {
			print or die $!; # skip non-actual z moves (already at the target height)
		}
		$cur_z = $new_z;
	}
	else {
		# nothing interesting, print line as-is
		print or die $!;
	}
}
