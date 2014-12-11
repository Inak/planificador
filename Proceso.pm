#!/usr/bin/perl

package Proceso;

sub new {
	my $class = shift;

	my $self = {
		nombre   => shift,
		id       => shift,
		padre_id => shift, # si es padre va el mismo id
		tipo     => shift,
		llegada  => shift,
		rafagas  => [ @_ ],
	};

	bless $self, $class;

	return $self;
}


#Obtenemos el tiempo de llegada del proceso
sub get_llegada {
	my ($self) = @_;
	return $self->{llegada};
}

#Metodo que devuelve la cantidad de rafagas que
#quedan por ejecutar
sub get_rafaga_actual {
	my ($self) = @_;
	return $self->{rafagas}[0]->get_cantidad();
}

#Metodo que borra la primer rafaga que ejecutaba hasta el momento
sub eliminar_rafaga_actual {
	my ($self) = @_;

	shift(@{$self->{rafagas}});
}

#Metodo que evalua si el profeso se quedo sin rafagas por ejecutar
sub proceso_con_rafagas {
	my ($self) = @_;

	$arraySize = scalar (@{$self->{rafagas}});
	if ($arraySize != 0) {
		return 1;
	} else {
		return 0;
	}
	
}

#Metodo que evalua si la proxima rafaga es de CPU
#1 en caso afirmativo, 0 en caso contrario
sub rafaga_cpu {
	my ($self) = @_;
	
	return $self->{rafagas}[0]->es_rafaga_cpu();
}

sub rafaga_wait_first {
	my ($self) = @_;
	
	return $self->{rafagas}[0]->es_rafaga_wait_first();
}

sub rafaga_wait_second {
	my ($self) = @_;
	
	return $self->{rafagas}[0]->es_rafaga_wait_second();
}

sub rafaga_wait_third {
	my ($self) = @_;
	
	return $self->{rafagas}[0]->es_rafaga_wait_third();
}


sub es_ult {
	my ($self) = @_;

	if ($self->{tipo} == 1) {
		return 1;
	} else {
		return 0;
	}
}

sub get_padre_id {
	my ($self) = @_;

	return $self->{padre_id};
}

sub get_id {
	my ($self) = @_;

	return $self->{id};
}

sub get_rafagas {
	my ($self) = @_;

	return @{$self->{rafagas}};
}

sub descontar_rafaga {
	my ($self) = @_;

	$self->{rafagas}[0]->restar_cantidad();
}

sub set_quantos {
	my ($self, $quantos_e) = @_;

	$self->{rafagas}[0]->set_quantos($quantos_e);
}

sub get_quantos {
	my ($self) = @_;

	return $self->{rafagas}[0]->get_quantos();
}

sub get_nombre {
	my ($self) = @_;

	return $self->{nombre};
}

# otros métodos...

sub getTotalRafagas {
	my($self) = @_;
	my $totalRafagas = 0;
	# agarra el array de la instancia
	my @rafagas = @{$self->{rafagas}};
	foreach $r (@rafagas) {
		$totalRafagas += $r->{cantidad};
	}
	# devuelve la suma
	return $totalRafagas;
}

sub mostrarCampos {
	my($self) = @_;
	print "Resumen proceso:\n";
	print "id: " . $self->{id} . "\n";
	print "nombre: " . $self->{nombre} . "\n";
	print "proceso padre: " . $self->{padre_id} . "\n";
	print "tipo de proceso: " . $self->{tipo} . "\n";
	print "tiempo de llegada: " . $self->{llegada} . "\n";
	print "\nRafagas:\n";
	foreach $r (@{$self->{rafagas}}) {
		$r->mostrarCampos();
	}
	print "\n";
}

sub esPadre {
	my($self) = @_;
	return $self->{id} == $self->{padre_id};
}

1;
