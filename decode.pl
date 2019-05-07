#!/usr/bin/perl
use warnings;
use strict;
use autodie;
use Fcntl 'SEEK_SET';

for my $src (@ARGV) {
	open my $rfh, "<:raw", $src;

	(my $dest = $src) =~ s/\.spd$/.txt/;
	die "$src doesn't look like spd file" if $src eq $dest;
	open my $wfh, ">", $dest;

	# 1024 looks like a fine header size, but there is
	# additional shift by 5 bytes for some reason
	seek $rfh, 1029, SEEK_SET;

	# the spectrum is stored in pairs of lambda, 1-T
	local $/ = \16;
	print $wfh (join("\t", unpack "d<2", $_), "\n")
		while (<$rfh>);
}
