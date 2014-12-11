package Salida;
use Proceso;
use diagnostics;

sub new {
	my $class = shift;
	
	my $self = {
		gantt =>[],
		cant_proc => 0,
		dir_tiempo => undef,
		ready_time => [],
		wait_first => [],
		wait_second => [],
		wait_third => [],
	};
	
	bless($self, $class);
	return $self;
}

sub inicializar {
	my ($self, @process) = @_;
	my $cont = 0;
	
	#Creamos los arrays de procesos
	foreach $proc(@process) {
		my $array = ();
		push @{$self->{gantt}[$cont]}, $proc->get_nombre();
		$cont++;
	}
	$self->{cant_proc} = $cont;
	push @{$self->{gantt}[$cont]}, "SO";
	#Seteamos el tiempo inicial
	$cont = $cont + 1;
	push @{$self->{gantt}[$cont]}, " ";
	$self->{dir_tiempo} = $cont;
}

sub set_tiempo {
	my ($self, $tiempo) = @_;

	if (length($tiempo) == 1) {
		$self->{gantt}[$self->{dir_tiempo}][scalar (@{$self->{gantt}[$self->{dir_tiempo}]})] = $tiempo."     ";
	} else {
		$self->{gantt}[$self->{dir_tiempo}][scalar (@{$self->{gantt}[$self->{dir_tiempo}]})] = $tiempo."    ";
	}
}

sub set_proceso {
	my ($self, $proc) = @_;
	
	for (my $item=0; $item < ($self->{cant_proc}+1); $item++) {
		if ($self->{gantt}[$item][0] eq $proc->get_nombre()) {
			push @{$self->{gantt}[$item]}, "X     ";
		} elsif (scalar (@{$self->{gantt}[$item]}) < scalar (@{$self->{gantt}[$self->{dir_tiempo}]})) {
			push @{$self->{gantt}[$item]}, "-     ";
		}
	}
	
}

sub set_so {
	my ($self, $proc) = @_;
	
	for (my $item=0; $item < ($self->{cant_proc}+1); $item++) {
		if ($self->{gantt}[$item][0] eq "SO") {
			push @{$self->{gantt}[$item]}, "X     ";
		} elsif (scalar (@{$self->{gantt}[$item]}) < scalar (@{$self->{gantt}[$self->{dir_tiempo}]})) {
			push @{$self->{gantt}[$item]}, "-     ";
		}
	}
	
}


sub set_wait_first_process {
	my ($self, $proceso, $wait_process) = @_;
	my $i_o = undef;

	if ($wait_process == 1) {
		$i_o = "I/O 1 ";
	} elsif ($wait_process == 2) {
		$i_o = "I/O 2 ";
	} else {
		$i_o = "I/O 3 ";
	}

	for (my $item=0; $item < $self->{cant_proc}; $item++) {
		if ($self->{gantt}[$item][0] eq $proceso->get_nombre()) {
			push @{$self->{gantt}[$item]}, $i_o;
		}
	}
}

sub set_ready_time {
	my ($self, @ready) = @_;

	push @{$self->{ready_time}[scalar (@{$self->{ready_time}})]}, @ready;
}

sub set_wait_first {
	my ($self, @wait_first) = @_;

	push @{$self->{wait_first}[scalar (@{$self->{wait_first}})]}, @wait_first;
}

sub set_wait_second {
	my ($self, @wait_second) = @_;

	push @{$self->{wait_second}[scalar (@{$self->{wait_second}})]}, @wait_second;
}

sub set_wait_third {
	my ($self, @wait_third) = @_;

	push @{$self->{wait_third}[scalar (@{$self->{wait_third}})]}, @wait_third;
}

sub mostrar {
	my ($self) = @_;
	my $cont = 0;
	my $long = 0;

	if (scalar (@{$self->{gantt}[$self->{dir_tiempo}]}) > 20) {
		$long = 20;
	} else {
		$long = scalar (@{$self->{gantt}[$self->{dir_tiempo}]}) - 1;
	}
	
	while ($cont < scalar (@{$self->{gantt}[$self->{dir_tiempo}]})) {
		#Impresion de los procesos
		for (my $item=0; $item < $self->{dir_tiempo}; $item++) {
			for ($item2=$cont; $item2 < $long; $item2++) {
				if ($item2 == 0) {
					if (length($self->{gantt}[$item][$item2]) < 8) {
						print $self->{gantt}[$item][$item2]."       ";
					} else {
						print $self->{gantt}[$item][$item2]." ";
					}
				} else {
					print $self->{gantt}[$item][$item2];
				}
			}
			print "\n";
		}
		
		#Impresion de los tiempos
		for ($item=$cont; $item < $long; $item++) {
			if ($item == 0) {
				print "TIEMPO   ";
			} else {
				print $self->{gantt}[$self->{dir_tiempo}][$item];
			}
		}

		print "\n";
		print "\n";
		print "\n";
		if ($long + 1 == scalar (@{$self->{gantt}[$self->{dir_tiempo}]})) {
			$cont = $long + 1;
		} else {
			$cont = $long;
		}
		$long = $long + (scalar (@{$self->{gantt}[$self->{dir_tiempo}]}) - $long);
		if ($long == scalar (@{$self->{gantt}[$self->{dir_tiempo}]})) {
			$long = $long - 1;
		}
	}
	
}

sub mostrar_historico {
	my ($self) = @_;
	my $tiempo = 0;
	
	print "\n";
	foreach my $item1(@{$self->{ready_time}}) {
		print "\n";
		printf "Tiempo %s: \n", $tiempo;
		foreach $item2(@{$self->{ready_time}[$tiempo]}) {
			if ($item2->get_id() == $self->{ready_time}[$tiempo][0]->get_id()) {
				printf "Proceso ejecutando: %s \n", $self->{ready_time}[$tiempo][0]->get_nombre();
				print "Ready: ";
			} else {
				printf "%s ", $item2->get_nombre();
			}
		}

		print "\n";
		print "I/O 1: ";
		foreach $item2(@{$self->{wait_first}[$tiempo]}) {
			printf "%s ", $item2->get_nombre();
		}

		print "\n";
		print "I/O 2: ";
		foreach $item2(@{$self->{wait_second}[$tiempo]}) {
			printf "%s ", $item2->get_nombre();
		}

		print "\n";
		print "I/O 3: ";
		foreach $item2(@{$self->{wait_third}[$tiempo]}) {
			printf "%s ", $item2->get_nombre();
		}

		$tiempo++;
		print "\n";
	}
	
}

1;
