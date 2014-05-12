# Importer module for MultiDisc Plugin
# Copyright (C) George Hines 2014

# This file is part of MultiDisc.
#
# MultiDisc is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# MultiDisc is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with MultiDisc; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

package Plugins::MultiDisc::Importer;

use strict;

use Slim::Formats;
use Slim::Formats::Playlists;

sub initPlugin {
	my $class = shift;

	# override parsing of Cue Files
	Slim::Formats::Playlists->registerParser('cue', 'Plugins::MultiDisc::Playlists::CUE');

	# override parsing of all non-playlist files
	while (my ($type, $class) = each %Slim::Formats::tagClasses) {
		# Skip playlists - this actually would be handled below.
		next if ($class =~ m/::Playlists::/);

		# Get package name of built-in formats
		next if not $class =~ m/Slim::Formats::([^:]+)$/;
		my $package = $1;

		# Replace it with our parser
		Slim::Formats::Playlists->registerParser($type, "Plugins::MultiDisc::Formats::$package");		
	}
}

1;

__END__
