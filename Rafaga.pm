#!/usr/bin/perl

package Rafaga;

sub new {
	my $class = shift;

	my $self = {
		tipo     => shift, # 1: CPU, 2: I/O, 3: I/O2, 4: I/O3
		cantidad => shift,
	};
	
	bless $self, $class;

	return $self;
}

sub mostrarCampos {
	my($self) = @_;
	print "Resumen Rafaga:\n";
	print "tipo: " . $self->{tipo} . "\n";
	print "cantidad: " . $self->{cantidad} . "\n";
}

1;
