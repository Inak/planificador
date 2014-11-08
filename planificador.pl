#!/usr/bin/env perl

use strict;
use warnings;
use Switch;

require 'pantallas/inicial.pl';
require 'pantallas/final.pl';

require 'utils.pl';

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
	algotitmoLibHilos => 0, # FIFO; RR, q = x, x != q del SO; HRRN; SPN; SRT # ingresar quantum de los hilos
	nucleos => 0, # 1..2
	procesos => 0, # 1..10
	quantum => 0, # min. 1 unidad de tiempo
	rafagas => 0, # 1..12 ESTO ES POR PROCESO!!
);

# procesos:
# revisar lo q nec. cada proceso.
## hilos: min. 1..3 KTL, 0..3 ULT.
## tiempo de llegada 0.
## CPU: cant. de rafagas (max 12) entre cpu o e/s (3 tipos).

# array que guarda el estado de la matriz en cada ráfaga
my @frames = ();

# tabla
my %tabla = (
	so => 0, #ejecución del SO
	id => 0,
	klt => 1,
	utl => 0,
	tiempoLlegada => 0,
	cpu1 => 0,
	es1 => 0,
	cpu2 => 0,
	es2 => 0,
	cpu3 => 0,
	es3 => 0,
);

# colas (guardamos el id de c/proceso)
my @ready = ();
my @wait = ();

###############################
### sub rutinas (funciones) ###
###############################

# planificador
sub planificador {
	&menu;
}

sub menu {
	# get opcion
	print "Opciones:\n";
	print "1 siguiente ciclo.\t";
	print "2 mostrar config.\t";
	print "3 salir.\n";
	my $opcion = <>;
	until($opcion =~ /^[1-2]$/) {
		$opcion = <>;
	}

	# opciones
	# 1: siguiente
	# 2: salir
	switch (int($opcion)) {
		# sigue procesando
		case 1 {
			&planificador;
		}
		# mostrar config.
		case 2 {
			&mostrarOpciones;
			&planificador;
		}
		# salir
		case 3 {
			&pantallaFinal;
		}
	}
}
