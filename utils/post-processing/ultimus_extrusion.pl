#!/usr/bin/perl -i

use strict;
use warnings;

my $cur_tool = 0; # current tool in use, zero index (consistent with T0, T1, ...)_
my $in_extrusion = 0; # flag for whether currently in an extrusion
my $l = "";

# read stdin and any/all files passed as parameters one line at a time
while (<>) {
	# if we find a toolchange command, update cur_tool
	if (/^T(\d+(\.\d+)?)/) {
		$cur_tool = $1;
		print or die $!;
		next
	}

	if ($cur_tool == 0) { #ignore everything for the FFF tool (tool 0)
		print or die $!;
		next;
	}

	# if we encounter an extrusion word and we are not using tool 0 (the FFF tool)
	if (/G1.*\s+E\s*(\d+(\.\d+)?)/ && !/; unretract/ && !/; retract/) {
		if (!$in_extrusion) { # if we are not currently in an extrusion, i.e. starting to extrude now
			$l = $l . "M7\n"; #valve open
			s/E\d+\.\d+//;
			$l = $l . $_;
			$in_extrusion = 1;
			next;
		}
		else {
			# chop off the extrusion word and reattach rest of line then append
			s/E\d+\.\d+//;
			$l = $l . $_;
			next;
		}
	}
	else { # no extrusion word in current line
		if ($in_extrusion) { # this could be end of an extrusion move
			if (/^G1/ && (/X/ || /Y/ || /Z/ || /; retract/)) { # extrusion is really done
				$l = $l . "M9\n"; #valve close
				$l = $l . $_; #concantenate current line
				$in_extrusion = 0;
			}
			else { # extrusion not done yet
				$l = $l . $_;
				next;
			}
		}
		else {
			$l = $_;
		}

	}
	#else {
		# nothing interesting, print line as-is
	print $l or die $!;
	$l = "";
	#}
}
