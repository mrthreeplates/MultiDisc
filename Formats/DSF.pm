# This file is automatically generated.
# Edit template.pl and run makeformats.bat to update all formats.
package Plugins::MultiDisc::Formats::DSF;
use parent 'Slim::Formats::DSF';

# Template file parser for MultiDisc Plugin
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

use strict;

use Plugins::MultiDisc::Plugin;

sub getTag {
	my $self = shift;

	# call the base class's getTag to get the tags
	my $tags = $self->SUPER::getTag(@_);

	Plugins::MultiDisc::Plugin::checkForSet($tags);

  return $tags;
}

1;

__END__