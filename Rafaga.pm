#!/usr/bin/perl

package Rafaga;

sub new {
	my $class = shift;

	my $self = {
		tipo     => shift,
		cantidad => shift,
	};
	
	bless $self, $class;

	return $self;
}

1;