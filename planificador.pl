#!/usr/bin/env perl


########## inicio! ##########

&pantallaInicial;
&pantallaFinal;

#############################


##########################
### variables globales ###
##########################

# opciones del usuario
%opciones = (
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

# caratula y carga de configuración del planificador
sub pantallaInicial {
	&clearScreen;
	print "TP 2: Sistemas Operativos\n\n";
	print "Planificador\n\n";
	print "Presione cualquier tecla para comenzar...\n";
	<>;
	&cargaConfig;
}

# carga la config. elegida por el usuario para el planificador
sub cargaConfig {
	# cantidad de nucleos del CPU
	&clearScreen;
	print "1: Numero de nucleos del CPU (1 o 2): ";
	$opciones{nucleos} = <>;
	while (not($opciones{nucleos} =~ /^[12]$/)) {
		print "1: La cantidad de nucleos solo puede ser 1 o 2: ";
		$opciones{nucleos} = <>;
	}
	&clearScreen;
	print "Cantidad de nucleos: " . $opciones{nucleos};

	# cantidad de PC's
	&clearScreen;
	print "1: Numero de procesos (1..10): ";
	$opciones{procesos} = <>;
	while (
		not($opciones{procesos} =~ /^[1-9]$/) &&
		not($opciones{procesos} =~ /^[1][0]$/)
	) {
		print "1: La cantidad de PC's solo puede ser de 1 a 10: ";
		$opciones{procesos} = <>;
	}
	&clearScreen;
	print "Cantidad de nucleos: " . $opciones{nucleos};
	print "Cantidad de PC's: " . $opciones{procesos};
}

# saludo de despedida (?)
sub pantallaFinal {
	&clearScreen;
	print "Chau!";
	<>;
}

# borra la terminal (puede no funcionar en algunas compus)
sub clearScreen {
	print "\033[2J"; #clear the screen
	print "\033[0;0H"; #jump to 0,0
}
