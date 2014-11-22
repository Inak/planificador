# caratula y carga de configuración del planificador
sub pantallaInicial {
	&clearScreen;
	print "*******************************************\n";
	print "* TP 2: Sistemas Operativos               *\n";
	print "*                                         *\n";
	print "* Planificador                            *\n";
	print "*******************************************\n";

	print "\nPresione enter para comenzar...";

	<>;
	&cargaConfig;
}

# carga la config. elegida por el usuario para el planificador
sub cargaConfig {

	&clearScreen;
	print "Comienze cargando los procesos:\n\n";
	# tipo de planificación
	print "1: Tipo de planificación de procesos (1: apropiativa: FIFO, 2: no apropiativa: SRT): ";
	chomp($opciones{tipoPlanificacion} = <>);
	until ($opciones{tipoPlanificacion} =~ /^[12]$/) {
		print "1: Ingrese 1 para apropiativa o 2 para no apropiativa: ";
		chomp($opciones{tipoPlanificacion} = <>);
	}
	&clearScreen;
	print "Tipo de planificación de procesos: " . $opciones{tipoPlanificacion};

	# cantidad de nucleos del CPU
	&clearScreen;
	print "2: Numero de nucleos del CPU (1 o 2): ";
	chomp($opciones{nucleos} = <>);
	until ($opciones{nucleos} =~ /^[12]$/) {
		print "2: La cantidad de nucleos solo puede ser 1 o 2: ";
		chomp($opciones{nucleos} = <>);
	}
	&clearScreen;
	print "Tipo de planificación: " . $opciones{tipoPlanificacion};
	print "Cantidad de nucleos: " . $opciones{nucleos};

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

	# cargar PC's, 1..10
	&cargarProcesos;

	# mostrar todo lo cargado
	print "Tipo de planificación de procesos: " . $opciones{tipoPlanificacion};
	print "Cantidad de nucleos: " . $opciones{nucleos};
	print "Algoritmo para la libreria de hilos: " . $opciones{algotitmoLibHilos};
	if ($opciones{algotitmoLibHilos} == 2) { print "Quantum: " . $opciones{quantum}; };
}

sub cargarProcesos {
	print "Cargar procesos:\n\n";
	print "Cargar proceso número: " . scalar @tabla + 1 . "\n";

	# TODO: falta terminar el loop de los procesos!

	# proceso a cargar en la tabla
	my %proceso = (
		id => scalar @tabla + 1,
		klt => 0,
		ult => 0,
		tiempoLlegada => 0,
		# ráfagas
		cpu1 => 0,
		es1 => 0,
		cpu2 => 0,
		es2 => 0,
		cpu3 => 0,
		es3 => 0
	);

	# cargar cant. de KLT's
	&clearScreen;
	print "Cantidad de KLT's (1 a 3): ";
	chomp($proceso{klt} = <>);
	until ($proceso{klt} =~ /^[1-3]$/) {
		print "La cantidad de KLT's debe ser de 1 a 3: ";
		chomp($proceso{klt} = <>);
	}

	# cargar cant. de ULT's
	&clearScreen;
	print "Cantidad de ULT's (0 a 3): ";
	chomp($proceso{ult} = <>);
	until ($proceso{ult} =~ /^[0-3]$/) {
		print "La cantidad de ULT's debe ser de 0 a 3: ";
		chomp($proceso{ult} = <>);
	}

	# tiempo de llegada
	&clearScreen;
	print "Seleccione tiempo de llegada: ";
	chomp($proceso{tiempoLlegada} = <>);
	until ($proceso{tiempoLlegada} =~ /^\d+$/ || $proceso{tiempoLlegada} =~ /^[0]$/) {
		print "El tiempo de llegada debe ser un entero mayor o igual a cero: ";
		chomp($proceso{tiempoLlegada} = <>);
	}

	# cargar ráfagas
	&clearScreen;
	$masRafagas = 1;
	$columna = 1; # 1..6, impares == CPU (1,3,5), pares E/S (2,4,6)
	until (
		&getTotalRafagas(%proceso) == 12 ||
		(&getTotalRafagas(%proceso) < 12 && !$masRafagas)
	) {
		print "Cargar hola de ráfagas de " . ($columna % 2 == 0 ? "E/S" : "CPU") . ": ";
		my $rafagas = 0;
		chomp($rafagas = <>);
		until (
			# comparo el string ingresado 1ero para validar si el tipo carga núms. neg. o caracteres
			($rafagas =~ /^[1-9]$/ || $rafagas =~ /^[1][0-2]$/) &&
			# luego valida que no se pase del total permitido
			$rafagas + &getTotalRafagas(%proceso) <= 12
		) {
			print "2\n";
			print "El número de ráfagas total por proceso es 12:\n";
			print "Ráfagas cargadas: " . &getTotalRafagas(%proceso) . "\n";
			print "Intentaste cargar " . $rafagas  . " intente denuevo: ";
			chomp($rafagas = <>);
		}
		# meter el valor
		if ($columna == 1) { $proceso{cpu1} = $rafagas; }
		elsif ($columna == 2) { $proceso{es1} = $rafagas; }
		elsif ($columna == 3) { $proceso{cpu2} = $rafagas; }
		elsif ($columna == 4) { $proceso{es2} = $rafagas; }
		elsif ($columna == 5) { $proceso{cpu3} = $rafagas; }
		elsif ($columna == 6) { $proceso{es3} = $rafagas; }
		# mas ráfagas?
		&clearScreen;
		if (getTotalRafagas(%proceso) < 12) {
			print "Quiere cargar más ráfagas? (y/n): ";
			my $eleccion;
			chomp($eleccion = <>);
			until ($eleccion =~ /^[yn]$/) {
				print "Opción invalida, ingrese 'y' para cargar más o 'n' para terminar la carga: ";
				chomp($eleccion = <>);
			}
			# más ráfagas?
			$masRafagas = $eleccion eq "y" ? 1 : 0;
		}
		# siguiente columna
		++$columna;
	}

	# mete el proceso en el array (tabla)
	push(@tabla, %proceso);

	# mostrar proceso
	print "Proceso:\n";
	print "$_ $proceso{$_}\n" for (keys %proceso);
}

1;
