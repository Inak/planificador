# imprime la config. del planificador
sub mostrarOpciones {
	&clearScreen;
	print "Tipo de planificación: " . $opciones{tipoPlanificacion};
	print "Cantidad de nucleos: " . $opciones{nucleos};
	print "Cantidad de PC's: " . $opciones{procesos};
	print "Rafagas del CPU: " . $opciones{rafagas};
}

# borra la terminal (puede no funcionar en algunas compus)
sub clearScreen {
	print "\033[2J"; #clear the screen
	print "\033[0;0H"; #jump to 0,0
}

# get total ráfagas de un proceso
sub getTotalRafagas {
	# para agarrar el hash que entra como parametro
	my %pc = @_;
	# suma de las ráfagas, retorna el total
	$_ = $pc{cpu1} + $pc{es1} + $pc{cpu2} + $pc{es2} + $pc{cpu3} + $pc{es3};
}

1;
