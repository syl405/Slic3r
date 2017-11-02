#!/usr/bin/perl -i

use strict;
use warnings;

my $offset_outstanding = 0; #toggle indicating whether there are outstanding offsets to apply
my $z = 0; #running tally of z height, in prevailing coordinate system (i.e. not considering G92 offsets)
my $prevailing_offset = 0; #G92 offset already applied, such that ($z + $cur_offset) = actual height in machine coordinate system
my $outstanding_offset = 0; #G92 offsets to be applied at next toolchange, such that ($z + $cur_offset) = actual height in machine coordinate system
my $offsets_pending = 0; #toggle of whether there are new offsets to apply
my $z_ref = 0; #target z to go to (in prevailing coordinate system, i.e. z') before zeroing out z axis.
my @tool_z_offsets = (0, 0, 0, 0); #initialize tool length ofsets (M6 offsets for hyrel) to zero
my $cur_tool_offset = 0;

# read stdin and any/all files passed as parameters one line at a time
while (<>) {
	#save tool length offsets from M6 commands
	if (/^M6\s+.*T1(\d)\s+.*Z(\d+(?:\.\d+)?)/) { #TO-DO: hyrel M6 tool numbers are 2-digit (e.g. T12) and 1-indexed!
		$tool_z_offsets[$1 - 1] = $2; #save tool length offset
		print or die $!;
		next;
	}

	# keep running tally of current z height
	if (/^G1\s+.*Z(\d+(\.\d+)?)/) {
		$z = $1;
		print or die $!;
		next;
	}
	
	# keep running tally of G92 offsets
	if (/G92\s+Z(\d+(?:\.\d+)?)/) {
		$outstanding_offset += (-$1 + $z);
		$z = $1;
		$offsets_pending = 1;
		print or die $!;
		next; #gobble up existing G92 commands
	}

	# if we find a toolchange command, apply any outstanding z offsets AFTER the toolchange
	if (/^T(\d)/) {
		print or die $!; #print out toolchange command
		if ($offsets_pending) {
			$z_ref = $outstanding_offset - $prevailing_offset;
			print "G1 Z$z_ref\n" or die $!; #move to z-zero for current object
			/^T(\d)/;
			$cur_tool_offset = $tool_z_offsets[$1];
			print "G92 Z-$cur_tool_offset\n" or die $!; #zero out z-axis here
			$prevailing_offset = $outstanding_offset;
			$offsets_pending = 0;
		}
		next;
	}

	
	
	#else {
		# nothing interesting, just print
	print or die $!;
}
