#!/usr/bin/env perl

use strict;
use warnings;

require 'pantallas/inicial.pl';
require 'pantallas/final.pl';
require 'utils.pl';

use Proceso;
use Rafaga;

########## inicio! ##########

&pantallaInicial;
&planificador;
&pantallaFinal;

#############################


##########################
### variables globales ###
##########################

# opciones del usuario
my %opciones = (
	tipoPlanificacion => 0, # apropiativa o !apropiativa
	nucleos => 0, # 1..2
	algotitmoLibHilos => 0, # FIFO; RR, q = x, x != q del SO; HRRN; SPN; SRT # ingresar quantum de los hilos
	quantum => 0, # solo si elige RR
);

# tabla de planificación, aca se cargan los PC's
my @tabla = ();

# estado de evolución del gantt
my %gantt = (
	tiempo => 0,
	so => 0,
	ejecutoPC => 0,
	finalizoPC => 0,
	ready => 0,
	wait => 0
);

# array que guarda el estado de la matriz en cada ráfaga
# max 120 rafagas (1..12 rafagas x 1..10 procesos)
my @frames = ();

# colas (guardamos el id de c/proceso)
my @ready = ();
my @wait = ();

###############################
### sub rutinas (funciones) ###
###############################

# planificador: entrada al algo. ppal.
sub planificador {
	&menu;
}

sub menu {
	# obtener opcion
	print "Opciones:\n";
	print "1 siguiente ciclo.\t";
	print "2 mostrar config.\t";
	print "3 salir.\n";
	my $opcion = <>;
	until($opcion =~ /^[1-3]$/) {
		$opcion = <>;
	}

	# Opciones:
	# TODO: modo interactivo, retroceder, avanzar, fin (va al gantt final)
	if (int($opcion) == 1) { &planificador; }
	# 2: mostrar config.
	elsif (int($opcion) == 2) { &mostrarOpciones; &planificador; }
	# 3: salir
	elsif (int($opcion) == 3) { &pantallaFinal; }
}
