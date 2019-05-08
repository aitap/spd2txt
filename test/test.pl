#!/usr/bin/perl
use warnings;
use strict;
use autodie;
use Test::More;

# with default export settings (are there any?),
# wavelength is specified to 1e-2 nm;
# 1-T is specified to 1e-3 relative units
my @tol = (5e-3, 5e-4);

sub similar {
	my ($dec, $org) = @_;
	open my $dfh, "<", $dec;
	open my $ofh, "<", $org;
	<$ofh>; # skip header line
	while (defined(my $oline = <$ofh>)) {
		my $dline = <$dfh>;
		unless (defined $dline) {
			diag "$dec is shorter than $org";
			return 0;
		}
		my @oval = split /\s+/, $oline;
		unless (@oval == @tol) {
			BAIL_OUT("$org doesn't have ".(scalar @tol)." columns");
		}
		my @dval = split /\s+/, $dline;
		unless (@dval == @tol) {
			diag("$dec doesn't have ".(scalar @tol)." columns");
			return 0;
		}
		for my $i (0..$#tol) {
			if (abs($oval[$i] - $dval[$i]) > $tol[$i]) {
				diag("$dec doesn't pass tolerance test, line ".$dfh->input_line_number.", col ".($i+1));
				return 0;
			}
		}
	}
	if (!defined <$dfh>) {
		return 1;
	} else {
		diag "$dec is longer than $org";
		return 0;
	}
}

for my $spd (glob "*.spd") {
	(my $txt = $spd) =~ s/\.spd/.txt/;
	(my $orig = $txt) =~ s/(?=\.txt)/_orig/;
	system("$^X ../decode.pl $spd");
	ok(similar($txt, $orig), "$spd - Perl");
	unlink($txt);
	system("lua5.3 ../decode.lua $spd");
	ok(similar($txt, $orig), "$spd - Lua");
	unlink($txt);
}

done_testing;
