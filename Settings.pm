# Settings module for MultiDisc Plugin
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

package Plugins::MultiDisc::Settings;

use strict;
use base qw(Slim::Web::Settings);

use Slim::Utils::Prefs;

my $prefs = preferences('plugin.multidisc');

sub name {
	return Slim::Web::HTTP::CSRF->protectName('PLUGIN_MULTI_DISC');
}

sub page {
	return Slim::Web::HTTP::CSRF->protectURI('plugins/MultiDisc/settings/basic.html');
}

sub prefs {
	return ($prefs, qw(set_suffix set_name original_name));
}

1;

__END__