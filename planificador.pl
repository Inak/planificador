#!/usr/bin/env perl

#use strict;
#use warnings;

use Planificador;
use Salida;
use Fifo;
use Srt;
use FifoUlt;
use SrtUlt;
use SpnUlt;
use HrrnUlt;
use RoundRobinUlt;
use Proceso;
use Rafaga;

##########################
### variables globales ###
##########################

# opciones del usuario
my %opciones = (
	tipoPlanificacion => 0, # 1: apropiativa: FIFO, 2: no apropiativa: SRT
	nucleos => 0, # 1..2
	algotitmoLibHilos => 0, # FIFO; RR, q = x, x != q del SO; HRRN; SPN; SRT # ingresar quantum de los hilos
	quantum => 0, # solo si elige RR
);

# tabla de planificación, aca se cargan los PC's
my $tabla = [];

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

# 1ero se carga el padre y luego los hijos
# flag para indicar que el proceso es padre, si es falso se carga el padre_id del proceso hijo
my $esPadre = 1;
my $cargarHijo = 0;



require 'pantallas/inicial.pl';
require 'pantallas/final.pl';
require 'utils.pl';



###############################
### sub rutinas (funciones) ###
###############################

# test
sub test {
	$procesos = [new Proceso("P1(ULT1)", 1, 1, 1, 0, @{[new Rafaga(0, 2), new Rafaga(3, 3), new Rafaga(0, 3)]})];

	$salida = new Salida();
	$salida->inicializar(@{$procesos});
	$planificador = new Planificador(new Srt(new RoundRobinUlt(1, 2)), 1, $salida, @{$procesos});
	$planificador->planificar_procesos();
}

# planificador: entrada al algo. ppal.
sub planificador {
#	print "-----\n";
#	print "Configuracion del planificador cargada:\n";
#	print "\nTipo de planificación de procesos: " . $opciones{tipoPlanificacion};
#	print "\nCantidad de nucleos: " . $opciones{nucleos};
#	print "\nAlgoritmo para la libreria de hilos: " . $opciones{algotitmoLibHilos};
#	if ($opciones{algotitmoLibHilos} == 2) { print "\tQuantum: " . $opciones{quantum}; };
#	print "\n";
#	print "-----\n";

	$salida = new Salida();
	$salida->inicializar(@tabla);

	# Fifo => 0
	# RR => 1
	# Hrrn => 2
	# Spn => 3
	# Srt => 4

	# 1: apropiativa: FIFO
	if ($opciones{tipoPlanificacion} == 1) {
		# 1: FIFO
		if ($opciones{algotitmoLibHilos} == 1) {
			$planificador = new Planificador(new Fifo(new FifoUlt(0)), $opciones{nucleos}, $salida, @tabla);
		# 2: RR, q = x, x != q del SO
		} elsif ($opciones{algotitmoLibHilos} == 2) {
			$planificador = new Planificador(new Fifo(new RoundRobinUlt(1, $opciones{quantum})), $opciones{nucleos}, $salida, @tabla);
		# 3: HRRN
		} elsif ($opciones{algotitmoLibHilos} == 3) {
			$planificador = new Planificador(new Fifo(new HrrnUlt(2)), $opciones{nucleos}, $salida, @tabla);
		# 4: SPN
		} elsif ($opciones{algotitmoLibHilos} == 4) {
			$planificador = new Planificador(new Fifo(new SpnUlt(3)), $opciones{nucleos}, $salida, @tabla);
		# 5: SRT
		} elsif ($opciones{algotitmoLibHilos} == 5) {
			$planificador = new Planificador(new Fifo(new SrtUlt(4)), $opciones{nucleos}, $salida, @tabla);
		}
	# 2: no apropiativa: SRT
	} else {
		# 1: FIFO
		if ($opciones{algotitmoLibHilos} == 1) {
			$planificador = new Planificador(new Srt(new FifoUlt(1)), $opciones{nucleos}, $salida, @tabla);
		# 2: RR, q = x, x != q del SO
		} elsif ($opciones{algotitmoLibHilos} == 2) {
			$planificador = new Planificador(new Srt(new RoundRobinUlt(1, $opciones{quantum})), $opciones{nucleos}, $salida, @tabla);
		# 3: HRRN
		} elsif ($opciones{algotitmoLibHilos} == 3) {
			$planificador = new Planificador(new Srt(new HrrnUlt(1)), $opciones{nucleos}, $salida, @tabla);
		# 4: SPN
		} elsif ($opciones{algotitmoLibHilos} == 4) {
			$planificador = new Planificador(new Srt(new SpnUlt(1)), $opciones{nucleos}, $salida, @tabla);
		# 5: SRT
		} elsif ($opciones{algotitmoLibHilos} == 5) {
			$planificador = new Planificador(new Srt(new SrtUlt(1)), $opciones{nucleos}, $salida, @tabla);
		}
	}

	$planificador->planificar_procesos();

	#&menu;
}

sub menu {
	# mostrar opciones
	print "Opciones:\n";
	print "1 avanzar.\t";
	print "2 retroceder.\t";
	print "3 ir al gantt final.\t";
	print "4 mostrar config.\t";
	print "5 salir.\n";

	# obtener opción
	my $opcion = <>;
	until($opcion =~ /^[1-5]$/) {
		$opcion = <>;
	}

	# avanzar
	if (int($opcion) == 1) { &planificador; }
	# retroceder
	elsif (int($opcion) == 2) { &planificador; }
	# ir al gantt final
	elsif (int($opcion) == 3) { &planificador; }
	# 2: mostrar config.
	elsif (int($opcion) == 4) { &mostrarOpciones; &planificador; }
	# 3: salir
	elsif (int($opcion) == 5) { &pantallaFinal; }
}

sub cargarOpcionesDelPlanificador {
	&clearScreen;
	print "Comienze cargando los datos a planificar:\n\n";
	# tipo de planificación
	print "1: Tipo de planificación de procesos (1: apropiativa: FIFO, 2: no apropiativa: SRT): ";
	chomp($opciones{tipoPlanificacion} = <>);
	until ($opciones{tipoPlanificacion} =~ /^[12]$/) {
		print "1: Ingrese 1 para apropiativa o 2 para no apropiativa: ";
		chomp($opciones{tipoPlanificacion} = <>);
	}
	&clearScreen;

	# cantidad de nucleos del CPU
#	&clearScreen;
#	print "2: Numero de nucleos del CPU (1 o 2): ";
#	chomp($opciones{nucleos} = <>);
#	until ($opciones{nucleos} =~ /^[12]$/) {
#		print "2: La cantidad de nucleos solo puede ser 1 o 2: ";
#		chomp($opciones{nucleos} = <>);
#	}
#	&clearScreen;
	$opciones{nucleos} = 1; # TODO: esto no está implementado

	# algoritmo para la lib. de hilos
	&clearScreen;
	print "3: Algoritmo para la libreria de hilos:\n";
	print "\tOpciones:\n";
	print "\t1: FIFO, 2: RR, 3: HRRN, 4: SPN, 5: SRT.\n";
	chomp($opciones{algotitmoLibHilos} = <>);
	until ($opciones{algotitmoLibHilos} =~ /^[12345]$/) {
		print "3: Eliga una opción correcta:\n";
		print "Opciones:\n";
		print "\t1: FIFO, 2: RR, 3: HRRN, 4: SPN, 5: SRT.\n";
		chomp($opciones{algotitmoLibHilos} = <>);
	}
	# elegir quantum solo si seleccionó RR
	if ($opciones{algotitmoLibHilos} == 2) {
		print "Seleccione el quantum: ";
		chomp($opciones{quantum} = <>);
		until ($opciones{quantum} =~ /^([0-9]|[1-9][0-9]|100)$/) { # TODO: bug: deja pasar cero.
			print "El quantum debe ser un número entero mayor a cero: ";
			chomp($opciones{quantum} = <>);
		}
	}
	&clearScreen;
	print "3: Algoritmo para la libreria de hilos: " . $opciones{algotitmoLibHilos};
	if ($opciones{algotitmoLibHilos} == 2) { print "\tQuantum: " . $opciones{quantum} . "\n"; }

	return %opciones;
}

sub mostrarLoCargado {
	# mostrar todo lo cargado
	&clearScreen;
	print "Configuracion del planificador cargada:\n";
	print "\nTipo de planificación de procesos: " . $opciones{tipoPlanificacion};
	print "\nCantidad de nucleos: " . $opciones{nucleos};
	print "\nAlgoritmo para la libreria de hilos: " . $opciones{algotitmoLibHilos};
	if ($opciones{algotitmoLibHilos} == 2) { print "\tQuantum: " . $opciones{quantum}; };
	print "\n";
	print "\nProcesos cargados:\n\n";
	foreach $p (@tabla) {
		$p->mostrarCampos();
	}
}

#############################
########## inicio! ##########
#############################

# casos de prueba
#&test;

# inicio e ingreso de datos.
&pantallaInicial;
%opciones = &cargarOpcionesDelPlanificador;
&cargarProcesos;

# mostrar lo cargado
&mostrarLoCargado;

# algoritmo ppal.
&planificador;

# saludo final.
#&pantallaFinal;

#############################
########### fin #############
#############################
