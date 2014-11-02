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

1;
