# Cue sheet parser for MultiDisc Plugin
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

package Plugins::MultiDisc::Playlists::CUE;
use parent 'Slim::Formats::Playlists::CUE';

use strict;

use Plugins::MultiDisc::Plugin;

sub parse {
	my $self = shift;

	# call the base class's parse to get the tracks
	my $tracks = $self->SUPER::parse(@_);

  return if not defined($tracks);

  foreach my $track (values %$tracks) {
		Plugins::MultiDisc::Plugin::checkForSet($track);
	}

  return $tracks;
}

1;

__END__
