#!/usr/bin/perl

package Rafaga;

sub new {
	my $class = shift;

	my $self = {
		tipo     => shift, # 1: CPU, 2: I/O, 3: I/O2, 4: I/O3
		cantidad => shift,
		quantos => 0,
	};
	
	bless $self, $class;

	return $self;
}

sub get_cantidad {
	my ($self) = @_;
	
	return $self->{cantidad};
}

sub es_rafaga_cpu {
	my ($self) = @_;

	if ($self->{tipo} == 0) {
		return 1;
	} else {
		return 0;
	}
}

sub es_rafaga_wait_first {
	my ($self) = @_;

	if ($self->{tipo} == 1) {
		return 1;
	} else {
		return 0;
	}
}

sub es_rafaga_wait_second {
	my ($self) = @_;

	if ($self->{tipo} == 2) {
		return 1;
	} else {
		return 0;
	}
}

sub es_rafaga_wait_third {
	my ($self) = @_;

	if ($self->{tipo} == 3) {
		return 1;
	} else {
		return 0;
	}
}

sub restar_cantidad {
	my ($self) = @_;

	$self->{cantidad} = $self->{cantidad} - 1;
	if ($self->{tipo} == 0 && $self->{quantos} > 0) {
		$self->{quantos} = $self->{quantos} - 1;
	}
	
}

sub get_quantos() {
	my ($self) = @_;

	return $self->{quantos};
}

# otros metodos...

sub mostrarCampos {
	my($self) = @_;
	print "Resumen Rafaga:\n";
	print "tipo: " . $self->{tipo} . "\n";
	print "cantidad: " . $self->{cantidad} . "\n";
}

1;
