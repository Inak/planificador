# caratula y carga de configuración del planificador
sub pantallaInicial {
	&clearScreen;
	print "TP 2: Sistemas Operativos\n\n";
	print "Planificador\n\n";
	print "Presione enter para comenzar...\n";
	<>;
	&cargaConfig;
}

# carga la config. elegida por el usuario para el planificador
sub cargaConfig {
	# tipo de planificación
	&clearScreen;
	print "1: Tipo de planificación (1: apropiativa, 2: no apropiativa): ";
	$opciones{tipoPlanificacion} = <>;
	until ($opciones{tipoPlanificacion} =~ /^[12]$/) {
		print "1: Ingrese 1 para apropiativa o 2 para no apropiativa: ";
		$opciones{tipoPlanificacion} = <>;
	}
	&clearScreen;
	print "Tipo de planificación: " . $opciones{tipoPlanificacion};

	# TODO: algoritmo para la lib. de hilos

	# cantidad de nucleos del CPU
	&clearScreen;
	print "3: Numero de nucleos del CPU (1 o 2): ";
	$opciones{nucleos} = <>;
	until ($opciones{nucleos} =~ /^[12]$/) {
		print "3: La cantidad de nucleos solo puede ser 1 o 2: ";
		$opciones{nucleos} = <>;
	}
	&clearScreen;
	print "Tipo de planificación: " . $opciones{tipoPlanificacion};
	print "Cantidad de nucleos: " . $opciones{nucleos};

	# cantidad de PC's
	&clearScreen;
	print "4: Numero de procesos (1..10): ";
	$opciones{procesos} = <>;
	while (
		not($opciones{procesos} =~ /^[1-9]$/) &&
		not($opciones{procesos} =~ /^[1][0]$/)
	) {
		print "4: La cantidad de PC's solo puede ser de 1 a 10: ";
		$opciones{procesos} = <>;
	}
	&clearScreen;
	print "Tipo de planificación: " . $opciones{tipoPlanificacion};
	print "Cantidad de nucleos: " . $opciones{nucleos};
	print "Cantidad de PC's: " . $opciones{procesos};

	# TODO quantum

	# cantidad de rafagas del CPU
	&clearScreen;
	print "6: Numero de rafagas del CPU (1..12): ";
	$opciones{rafagas} = <>;
	until (
		$opciones{rafagas} =~ /^[1-9]$/ ||
		$opciones{rafagas} =~ /^[1][0-2]$/
	) {
		print "6: La cantidad de rafagas del CPU solo puede ser de 1 a 12: ";
		$opciones{rafagas} = <>;
	}
	&clearScreen;
	print "Tipo de planificación: " . $opciones{tipoPlanificacion};
	print "Cantidad de nucleos: " . $opciones{nucleos};
	print "Cantidad de PC's: " . $opciones{procesos};
	print "Rafagas del CPU: " . $opciones{rafagas};
}

1;
