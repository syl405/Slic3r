#!/usr/bin/perl -i

use strict;
use warnings;

my $obj_comp = 0; #toggle indicating an object is completed, and the next object is about to begin

# read stdin and any/all files passed as parameters one line at a time
while (<>) {
	# if we find a toolchange command, update cur_tool
	if (/move to origin position for next object/) {
		$obj_comp = 1;
		print or die $!;
		next
	}

	if (!$obj_comp) { #ignore everything that isn't after completion, before toolchange
		print or die $!;
		next;
	}elsif (/G1.*\s+Z\s*\d+(\.\d+)?/ && /; move to next layer/) {
		$obj_comp = 0; #toggle off, now that we have stripped the layer drop
		next;
	}else {
		print or die $!;
		next;
	}
	#else {
		# if we get here something is wrong
	die $!;
}
