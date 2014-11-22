#!/usr/bin/perl

package Proceso;

sub new {
	my $class = shift;

	my $self = {
		id       => shift,
		padre_id => shift,
		tipo     => shift,
		llegada  => shift,
		refagas  => [ @_ ],
	};

	bless $self, $class;

	return $self;
}

sub add {
	my ( $self, $rafaga ) = @_;
	$self->{rafagas} = \@rafaga;
}

sub getRafagas {
	my( $self ) = @_;
	my @path = @{ $self->{rafagas} };
	wantarray ? @path : \@path;
	return $path;
}

1;