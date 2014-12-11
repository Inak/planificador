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
}

sub cargarProcesos {
	&clearScreen;
	print "Cargar procesos...\n";
	$masProcesos = 0;

	# el ultimo padre
	my $ultimoProceso;
	my $esHijo = 0;

	&cargarProcesoEnTabla($ultimoProceso);
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
		}
	}
}

sub cargarProcesoEnTabla {
	# proceso a cargar en la tabla
	my $proceso = new Proceso(scalar @tabla + 1);

	# id del PC
	$proceso->{id} = scalar @tabla + 1;

	# el 1er proceso que cargamos es padre si o si
	if (scalar @tabla + 1 == 1) {
		$proceso->{padre_id} = $proceso->{id};
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
	--$proceso->{tipo};

	# logica para los procesos hijos
	if (scalar @tabla + 1 > 1) {
		# 1er proceso padre es el 1ero del array
		if (scalar @tabla + 1 == 2) { $ultimoProceso = $tabla[0]; }

		# si es padre se pregunta si quiere cargar hilos hijos
		if ($ultimoProceso->esPadre()) {
			# revisar que no exceda 3 hijos KLT o 3 hijos ULT
			my $puedeCargarHijo = 0;
			my $hilosKLT = 0;
			my $hilosULT = 0;
			foreach $pc (@tabla) {
				if ($ultimoProceso->{id} == $pc->{padre_id}) {
					if ($pc->{tipo} == 0) {
						++$hilosKLT;
					} elsif ($pc->{tipo} == 1) {
						++$hilosULT;
					}
				}
			}
			if (
				($hilosKLT < 3 && $proceso->{tipo} == 1) ||
				($hilosULT < 3 && $proceso->{tipo} == 2)
			) {
				$proceso->{padre_id} = $ultimoProceso->{id};
			}

			&clearScreen;
			print "Asociar el sig. proceso como hilo del proceso " . $ultimoProceso->{nombre} . "? (y/n): ";
			my $eleccion;
			chomp($eleccion = <>);
			until ($eleccion =~ /^[yn]$/) {
				print "Opción invalida, ingrese 'y' para cargar más o 'n' para terminar la carga: ";
				chomp($eleccion = <>);
			}
			# más procesos?
			$esHijo = $eleccion eq "y" ? 1 : 0;
		}
	}
	if ($esHijo) {
		$proceso->{padre_id} = $ultimoProceso->{id};
		$proceso->{llegada} = $ultimoProceso->{llegada};
		# TODO: construir nombre del hilo
		$proceso->{nombre} = "H" . $proceso->{id};
	} else {
		# tiempo de llegada
		&clearScreen;
		print "Cargar proceso número: " . scalar @tabla + 1 . "\n\n";
		print "Seleccione tiempo de llegada: ";
		chomp($proceso->{llegada} = <>);
		until ($proceso->{llegada} =~ /^\d+$/ || $proceso->{llegada} =~ /^[0]$/) {
			print "El tiempo de llegada debe ser un entero mayor o igual a cero: ";
			chomp($proceso->{llegada} = <>);
		}

		# cargar nombre
		&clearScreen;
		print "Cargar nombre del proceso (min. 1 caracter, máx. 8 caracteres): ";
		chomp($proceso->{nombre} = <>);
		until ($proceso->{nombre} =~ /^[a-z0-9\s]{1,8}$/i) {
			print "El nombre debe consistir en una cadena de 1 a 8 caracteres: ";
			chomp($proceso->{nombre} = <>);
		}

		$proceso->{padre_id} = $proceso->{id};
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

		# la 1era es de CPU
		if ($proceso->getTotalRafagas() == 0) {
			$rafaga->{tipo} = 0;
		# las demás puede elegir cualquiera
		} else {
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
			--$rafaga->{tipo};
		}

		# catn. de rafagas
		&clearScreen;

		if ($proceso->getTotalRafagas() == 0) { print "La 1era ola de ráfagas es del CPU.\n"; }

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
		push(@{$proceso->{rafagas}}, $rafaga);

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

	# sino es hijo seria el ultimo padre
	if ($esHijo == 0) {
		$ultimoProceso = $proceso;
	}

	# mete el proceso en el array (tabla)
	push(@tabla, $proceso);
}

1;
