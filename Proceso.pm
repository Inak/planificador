#!/usr/bin/perl

package Proceso;

sub new {
	my $class = shift;

	my $self = {
		id       => shift,
		padre_id => shift,
		tipo     => shift,
		llegada  => shift,
		rafagas  => [ @_ ],
	};

	bless $self, $class;

	return $self;
}

1;