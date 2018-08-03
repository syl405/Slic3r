#!/usr/bin/perl -i

use strict;
use warnings;

my $cur_tool = 0; # current tool in use, zero index (consistent with T0, T1, ...)_
my $in_extrusion = 0; # flag for whether currently in an extrusion
my $cur_extrusion_time = 0; #cumulative duration in current extrusion
my $l = "";

my $x = 0;
my $y = 0;
my $z = 0;
my $f = 0;

my $refill_sequence = "M9\nG91 ;relative\nG1 Z20 F350 ;lift for refill\nM0 ;please refill and prime\nG1 Z-20 F350\nG90 ;absolute\nM7\n";

# read stdin and any/all files passed as parameters one line at a time
while (<>) {
	# if we find a toolchange command, update cur_tool
	if (/^T(\d+(\.\d+)?)/) {
		$cur_tool = $1;
		$cur_extrusion_time = 0; #reset extrusion time for new tool
		print or die $!;
		next
	}

	if ($cur_tool == 0) { #ignore everything for the FFF tool (tool 0)
		print or die $!;
		next;
	}


	if(/M7$/ && !$in_extrusion) { #enter extrusion
		$in_extrusion = 1;
		print or die $!;
		next;
	}

	if(/M9$/ && $in_extrusion) { #exit extrusion
		$in_extrusion = 0;
		print or die $!;
		next;
	}


	if ($in_extrusion && /^G1/ && (/X/ || /Y/ || /Z/)) { #if we encounter a move while in extrusion
		my $next_x = $x;
		my $next_y = $y;
		my $next_z = $z;
		my $dist = 0;

		if (/\s+X(-?\d+\.?\d+)/) {
			$next_x = $1;
		}
		if (/\s+Y(-?\d+\.?\d+)/) {
			$next_y = $1;
		}
		if (/\s+Z(-?\d+\.?\d+)/) {
			$next_z = $1;
		}
		if (/\s+F(\d+\.?\d+)/) {
			$f = $1;
		}
		$dist = sqrt(($next_x - $x)**2 + ($next_y - $y)**2 + ($next_z - $z)**2); #calculate straight line distance
		$x = $next_x;
		$y = $next_y;
		$z = $next_z;
		$cur_extrusion_time = $cur_extrusion_time + ($dist/$f);
		if ($cur_extrusion_time > 3.5) {
			$refill_sequence = "M9\nG1 Z" . ($z + 20) . " F350 ;lift for refill\nM0 ;please refill and prime\nG1 Z" . $z ." F350\nM7\n";
			print $refill_sequence or die $!;
			$cur_extrusion_time = 0; #reset current extrusion time
		}
		print or die $!;
		next;
	}
	elsif (/^G1/ && (/X/ || /Y/ || /Z/)) { #keep tracking current position
		if (/\s+X(-?\d+\.?\d+)/) {
			$x = $1;
		}
		if (/\s+Y(-?\d+\.?\d+)/) {
			$y = $1;
		}
		if (/\s+Z(-?\d+\.?\d+)/) {
			$z = $1;
		}
		if (/\s+F(\d+\.?\d+)/) {
			$f = $1;
		}

	}

	#else {
		# nothing interesting, print line as-is
	print or die $!;
	#}
}
