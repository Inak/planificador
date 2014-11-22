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
	print "Comienze cargando los datos a planificar:\n\n";
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

sub cargarProcesos {
	&clearScreen;
	print "Cargar procesos...\n";
	$masProcesos = 0;
	&cargarProcesoEnTabla;
	&clearScreen;
	print "Quiere cargar más procesos? (y/n): ";
	my $eleccion;
	chomp($eleccion = <>);
	until ($eleccion =~ /^[yn]$/) {
		print "Opción invalida, ingrese 'y' para cargar más o 'n' para terminar la carga: ";
		chomp($eleccion = <>);
	}
	# más procesos?
	$masProcesos = $eleccion eq "y" ? 1 : 0;
	while (scalar @tabla < 10 && $masProcesos) {
		&cargarProcesoEnTabla();
		if (scalar @tabla < 10) {
			print "Quiere cargar más procesos? (y/n): ";
			my $eleccion;
			chomp($eleccion = <>);
			until ($eleccion =~ /^[yn]$/) {
				print "Opción invalida, ingrese 'y' para cargar más o 'n' para terminar la carga: ";
				chomp($eleccion = <>);
			}
			# más procesos?
			$masProcesos = $eleccion eq "y" ? 1 : 0;
		}
	}
}

sub cargarProcesoEnTabla {
	# proceso a cargar en la tabla
	my $proceso = new Proceso(scalar @tabla + 1);

	# tiempo de llegada
	&clearScreen;
	print "Cargar proceso número: " . scalar @tabla + 1 . "\n\n";
	print "Seleccione tiempo de llegada: ";
	chomp($proceso->{llegada} = <>);
	until ($proceso->{llegada} =~ /^\d+$/ || $proceso->{llegada} =~ /^[0]$/) {
		print "El tiempo de llegada debe ser un entero mayor o igual a cero: ";
		chomp($proceso->{llegada} = <>);
	}

	# es KLT o ULT?
	&clearScreen;
	print "Seleccione tipo de hilo:\n";
	print "\t1: KLT, 2: ULT.\n";
	chomp($proceso->{tipo} = <>);
	until ($proceso->{tipo} =~ /^[12]$/) {
		print "Eliga una opción correcta:\n";
		print "Opciones:\n";
		print "\t1: KLT, 2: ULT.\n";
		chomp($proceso->{tipo} = <>);
	}

	# cargar ráfagas
	&clearScreen;
	$masRafagas = 1;
	until (
		$proceso->getTotalRafagas() == 12 ||
		($proceso->getTotalRafagas() < 12 && !$masRafagas)
	) {
		my $indice = 0;
		my $rafaga = new Rafaga();

		# tipo de rafaga
		&clearScreen;
		print "Seleccione tipo de ráfaga:\n";
		print "\tOpciones:\n";
		print "\t1: CPU, 2: I/O1, 3: I/O2, 4: I/O3.\n";
		chomp($rafaga->{tipo} = <>);
		until ($rafaga->{tipo} =~ /^[1-4]$/) {
			print "Eliga una opción correcta:\n";
			print "Opciones:\n";
			print "\t1: CPU, 2: I/O1, 3: I/O2, 4: I/O3.\n";
			chomp($rafaga->{tipo} = <>);
		}

		# catn. de rafagas
		&clearScreen;
		print "Cargar cantidad de ráfagas: ";
		my $rafagas = 0;
		chomp($rafagas = <>);
		until (
			# validar >= 12
			($rafagas =~ /^[1-9]$/ || $rafagas =~ /^[1][0-2]$/) &&
			# luego valida que no se pase del total permitido
			$rafagas + $proceso->getTotalRafagas() <= 12
		) {
			print "El número de ráfagas máximo por proceso es 12:\n";
			print "Ráfagas cargadas: " . $proceso->getTotalRafagas() . "\n";
			print "Intentaste cargar " . $rafagas  . " intente denuevo: ";
			chomp($rafagas = <>);
		}

		$rafaga->{cantidad} = $rafagas;

		# cargar rafaga al proceso
		push($proceso->{rafagas}, $rafaga);

		# mas ráfagas?
		&clearScreen;
		if ($proceso->getTotalRafagas() < 12) {
			print "Quiere cargar más ráfagas? (y/n): ";
			my $eleccion;
			chomp($eleccion = <>);
			until ($eleccion =~ /^[yn]$/) {
				print "Opción invalida, ingrese 'y' para cargar más o 'n' para terminar la carga: ";
				chomp($eleccion = <>);
			}
			# más ráfagas?
			$masRafagas = $eleccion eq "y" ? 1 : 0;
			$indice += 1;
		}
	}

	# mete el proceso en el array (tabla)
	push(@tabla, $proceso);
}

1;
