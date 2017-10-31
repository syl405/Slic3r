#!/usr/bin/perl -i

use strict;
use warnings;

my $f = 0;

# read stdin and any/all files passed as parameters one line at a time
while (<>) {
	# if we find a Z word, save it
	$f = $1 if /F\s*(\d+(\.\d+)?)/;

	# if we don't have Z, but we do have X and Y
	if (!/F/ && /X/ && /Y/ && $f) {
		# chop off the end of the line (incl. comments), saving chopped section in $1
		s/\s*([\r\n\;\(].*)/" F$f $1"/es;
		# print start of line, insert our Z value then re-add the chopped end of line
		# print "$_ Z$z $1";
	}
	#else {
		# nothing interesting, print line as-is
	print or die $!;
	#}
}
