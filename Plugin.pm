# MultiDisc Plugin for Logitech Media Server
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

package Plugins::MultiDisc::Plugin;

use strict;
use base qw(Slim::Plugin::Base);

use Slim::Utils::Prefs;
use Slim::Utils::Log;

if ( main::WEBUI ) {
	require Plugins::MultiDisc::Settings;
}

my $prefs = preferences("plugin.multidisc");

$prefs->set('set_suffix', ' - box') unless $prefs->exists('set_suffix');
my $setSuffix = $prefs->get('set_suffix');
$prefs->setChange(sub {$setSuffix = $_[1]}, 'set_suffix');

$prefs->set('set_name', 'SETNAME') unless $prefs->exists('set_name');
my $setName = $prefs->get('set_name');
$prefs->setChange(sub {$setName = $_[1]}, 'set_name');

$prefs->set('original_name', 'Original album name:') unless $prefs->exists('original_name');
my $originalName = $prefs->get('original_name');
$prefs->setChange(sub {$originalName = $_[1]}, 'original_name');

sub initPlugin {
	my $class = shift;

	$class->SUPER::initPlugin();

	if ( main::WEBUI ) {
		Plugins::MultiDisc::Settings->new;
	}
}

sub getDisplayName {
	return 'PLUGIN_MULTI_DISC';
}

# Try to guess disc # if this looks like it might be part of a set
sub checkForSet {
	my $tags = shift;

	# Look for things like (disc 1 of 2), CD #1, etc.  Make sure there
	# are enough variations that the search isn't too picky yet doesn't
	# return any false matches.
	my $album = $tags->{'ALBUM'};
	my $orig_album = $album;
	my $discnum = $tags->{'DISC'};
	if (defined $album and !defined $discnum and
			$album =~ m/(?:^|[^a-zA-Z]) ((?:CD|disc) [\#\.\-_\s]* (\d+) (?:\s* (?:of|\/) \s* (\d+))?)/xi) {
		my $discpat = $1;
		$discnum = $2;
		my $disctotal = $3;

		# Remove the original pattern - this may leave strange patterns
		# in the album name.  These are ugly and can interfere with combining
		# the discs in a single collection.
		$album =~ s/\Q$discpat//;

		# Remove any empty brackets (e.g (), [], etc.) which may have
		# enclosed the disc pattern.
		$album =~ s/ [\[\(\{] \s* [\}\)\]]//x;

		# Remove any trailing spaces, leading spaces or dangling punctuation.
		$album =~ s/\s*$//;
		$album =~ s/\s* [,\-_:] $//x;
		$album =~ s/^\s*//;
		$album =~ s/^ [,\-_:] \s*//x;

		# Remove any mismatched punctionation when the disc number is adjacent
		# to a bracket, parenthesis, etc.
		$album =~ s/\s* [\-,:] \s* ([:\)\-\]])/\1/x;
		$album =~ s/([:\(\-\[]) \s* [\-,:] \s*/\1/x;

		# Remove any double spaces.
		$album =~ tr/  / /s;

		# Remove leading zero in disc number.
		$discnum =~ s/^0(\d)/$1/;

		# Optionally flag this album as being part of a set since we have removed
		# the disc number.  This makes it easy to search for sets as well
		# as review how well this code is working.
		$album .= $setSuffix if $setSuffix ne '';

		$tags->{'ALBUM'} = $album;
		$tags->{'DISC'} = $discnum;
		$tags->{'DISCC'} = $disctotal if defined $disctotal;
	}

	# Optionally allow overriding of the set name via the comment tag.
	# This can be useful in case the set name isn't simply the name
	# of the album without the disc number.
	my $comment = $tags->{'COMMENT'};
	if (defined $comment and $setName ne '' and $comment =~ s/\Q$setName\E \s+ ([^\s]+)//xi) {
		# Don't add the set suffix, as it may not make sense in all cases.
		$tags->{'ALBUM'} = $1;
	}

	# Optionally save the original album name in the comment.
	if ($originalName ne '' and $orig_album ne $tags->{'ALBUM'}) {
		$tags->{'COMMENT'} = "$comment $originalName $orig_album";
	}

	return;
}

1;

__END__