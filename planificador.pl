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
	algotitmoLibHilos => 0, # FIFO; RR, q = x, x != q del SO; HRRN; SPN; SRT
	nucleos => 0, # 1..2
	procesos => 0, # 1..10
	quantum => 0, # min. 1 unidad de tiempo
	rafagas => 0, # 1..12, cpu o e/s
);

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
