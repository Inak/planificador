package Planificador;
use Srt;
use Fifo;
use SrtUlt;
use SpnUlt;
use FifoUlt;
use RoundRobinUlt;
use HrrnUlt;
use Salida;
use Proceso;
use Rafaga;


sub new {
	
	my $class = shift;
	my $self = {
		politica_cpu => shift,
		nucleos => shift,
		salida => shift,
		procesos => [@_],
		ready => [],
		wait_first => [],
		wait_second => [],
		wait_third => [],
		tiempo => 0,
		foo => [],
		padre_id => -1,
	};

	bless($self, $class);
    return $self;

}

sub planificar_procesos {
	my ($self) = @_;
	my @aux;

	$self->{politica_cpu}->set_salida($self->{salida});
	@aux = $self->nuevos_procesos_ready();
	if (scalar (@aux) > 0) {
		foreach my $proc_c(@aux) {
			push @{$self->{ready}}, $proc_c;
		}
	}
	$self->{salida}->set_tiempo($self->{tiempo});

	while (scalar (@{$self->{ready}}) > 0 || scalar (@{$self->{wait_first}}) > 0 || scalar (@{$self->{wait_second}}) > 0
			|| scalar (@{$self->{wait_third}}) > 0) {

		$self->{salida}->set_ready_time(@{$self->{ready}});
		$self->{salida}->set_wait_first(@{$self->{wait_first}});
		$self->{salida}->set_wait_second(@{$self->{wait_second}});
		$self->{salida}->set_wait_third(@{$self->{wait_third}});
		$self->proceso_in_action();
		$self->{tiempo} = $self->{tiempo} + 1;
		$self->{salida}->set_tiempo($self->{tiempo});

		@aux = $self->nuevos_procesos_ready();
		if (scalar (@aux) > 0) {
			foreach my $proc_a(@aux) {
				push @{$self->{ready}}, $proc_a;
			}
		}
	}

	$self->{salida}->mostrar();

}

sub proceso_in_action {
	my ($self) = @_;
	my $proc;

	
	
	$proc = $self->{politica_cpu}->proximo_proceso($self->{tiempo}, @{$self->{ready}});
	$self->planificar_wait();
	if ($self->{padre_id} != -1 && $proc->get_padre_id() == $self->{padre_id} && $proc->es_ult()) {
		$self->{salida}->set_so();
	} elsif ($proc->get_id() != -1) {
			$self->{politica_cpu}->set_ready(@{$self->{ready}});
			$self->{politica_cpu}->set_wait_first(@{$self->{wait_first}});
			$self->{politica_cpu}->set_wait_second(@{$self->{wait_second}});
			$self->{politica_cpu}->set_wait_third(@{$self->{wait_third}});
			$self->{politica_cpu}->procesar($proc);
			@{$self->{ready}} = $self->{politica_cpu}->get_ready();
			@{$self->{wait_first}} = $self->{politica_cpu}->get_wait_first();
			@{$self->{wait_second}} = $self->{politica_cpu}->get_wait_second();
			@{$self->{wait_third}} = $self->{politica_cpu}->get_wait_third();

	} else {
			$self->{salida}->set_so();
	}
	#$self->{salida}->set_proceso($proc);

}

sub planificar_wait {
	my ($self) = @_;
	my $aux = 0;

	$self->{padre_id} = -1;
	if (scalar (@{$self->{wait_first}}) > 0) {
		$self->{salida}->set_wait_first_process($self->{wait_first}[0], 1);

		$self->{wait_first}[0]->descontar_rafaga();
		if ($self->{wait_first}[0]->get_rafaga_actual() == 0) {
			my $proc = $self->{wait_first}[0];
			$proc->eliminar_rafaga_actual();
			#Borramos el proceso que acaba de finalizar en wait_first
			shift(@{$self->{wait_first}});

			if ($proc->es_ult()) {
				#Obtenemos los procesos relacionados al proceso
				#que acaba de finalizar en la wait_first
				@{$self->{foo}} = $self->get_process_ult($proc, @{$self->{wait_first}});
				#Actualizamos wait_first con los procesos no asociados al proceso finalizado
				@{$self->{wait_first}} = $self->get_process_not_rel($proc, @{$self->{wait_first}});
				$self->{padre_id} = $proc->get_padre_id();
				$aux = 1;
			}

			if ($proc->proceso_con_rafagas()) {
				#agregamos el proceso a la cola auxiliar
				push @{$self->{foo}}, $proc;
			}

			if (scalar (@{$self->{foo}}) != 0) {
				#Movemos los procesos de la cola auxiliar. El destino dependera
				#del proceso que se encuentre como primer elemento
				$self->mover_procesos();
			}

		}
	}

	if (scalar (@{$self->{wait_second}}) > 0) {
		$self->{salida}->set_wait_first_process($self->{wait_second}[0], 2);
		$self->{wait_second}[0]->descontar_rafaga();
		if ($self->{wait_second}[0]->get_rafaga_actual() == 0) {
			my $proc = $self->{wait_second}[0];
			$proc->eliminar_rafaga_actual();
			#Borramos el proceso que acaba de finalizar en wait_second
			shift(@{$self->{wait_second}});

			if ($proc->es_ult()) {
				#Obtenemos los procesos relacionados al proceso
				#que acaba de finalizar en la wait_second
				@{$self->{foo}} = $self->get_process_ult($proc, @{$self->{wait_second}});
				#Actualizamos wait_second con los procesos no asociados al proceso finalizado
				@{$self->{wait_second}} = $self->get_process_not_rel($proc, @{$self->{wait_second}});
				if ($aux == 0) {
					$self->{padre_id} = $proc->get_padre_id();
					$aux = 1;
				}
			}

			if ($proc->proceso_con_rafagas()) {
				#agregamos el proceso a la cola auxiliar
				push @{$self->{foo}}, $proc;
			}

			if (scalar (@{$self->{foo}}) != 0) {
				#Movemos los procesos de la cola auxiliar. El destino dependera
				#del proceso que se encuentre como primer elemento
				$self->mover_procesos();
			}
		}
	}

	if (scalar (@{$self->{wait_third}}) > 0) {
		$self->{salida}->set_wait_first_process($self->{wait_third}[0], 3);
		$self->{wait_third}[0]->descontar_rafaga();
		if ($self->{wait_third}[0]->get_rafaga_actual() == 0) {
			my $proc = $self->{wait_third}[0];
			$proc->eliminar_rafaga_actual();
			#Borramos el proceso que acaba de finalizar en wait_third
			shift(@{$self->{wait_third}});

			if ($proc->es_ult()) {
				#Obtenemos los procesos relacionados al proceso
				#que acaba de finalizar en la wait_third
				@{$self->{foo}} = $self->get_process_ult($proc, @{$self->{wait_third}});
				#Actualizamos wait_third con los procesos no asociados al proceso finalizado
				@{$self->{wait_third}} = $self->get_process_not_rel($proc, @{$self->{wait_third}});
				if ($aux == 0) {
					$self->{padre_id} = $proc->get_padre_id();
					$aux = 1;
				}
			}

			if ($proc->proceso_con_rafagas()) {
				#agregamos el proceso a la cola auxiliar
				push @{$self->{foo}}, $proc;
			}

			if (scalar (@{$self->{foo}}) != 0) {
				#Movemos los procesos de la cola auxiliar. El destino dependera
				#del proceso que se encuentre como primer elemento
				$self->mover_procesos();

			}
		}
	}

	@{$self->{foo}} = ();

}

sub mover_procesos {
	my ($self) = @_;
	my $proc = $self->{foo}[0];

	if ($proc->rafaga_cpu()) {
		foreach my $proc_a(@{$self->{foo}}) {
			push @{$self->{ready}}, $proc_a;
		}
	} elsif ($proc->rafaga_wait_first()) {
		foreach my $proc_a(@{$self->{foo}}) {
			push @{$self->{wait_first}}, $proc_a;
		}
	} elsif ($proc->rafaga_wait_second()) {
		foreach my $proc_a(@{$self->{foo}}) {
			push @{$self->{wait_second}}, $proc_a;
		}
	} elsif ($proc->rafaga_wait_third()) {
		foreach my $proc_a(@{$self->{foo}}) {
			push @{$self->{wait_third}}, $proc_a;
		}
	}
	
}

sub get_process_ult {
	my ($self, $proc, @foo_p) = @_;
	my @foo_aux = ();

	foreach my $proc_a(@foo_p) {
		if ($proc->get_padre_id() == $proc_a->get_padre_id() && $proc->es_ult()) {
			push @foo_aux, $proc_a;
		}
	}

	return @foo_aux;
}

sub get_process_not_rel() {
	my ($self, $proc, @foo_p) = @_;
	
	my @foo_aux = ();
	foreach my $proc_a(@foo_p) {
		if ($proc->get_padre_id() != $proc_a->get_padre_id() || !$proc_a->es_ult()) {
			push @foo_aux, $proc_a;
		}
	}

	return @foo_aux;
}

#Este metodo busca los nuevos procesos que ingrasan al contexto
#de planificacion, o sea, aquellos cuyo tiempo de ingreso coincide
#coincide con el actual
sub nuevos_procesos_ready {

	my ($self) = @_;
	my @nuevos_procesos = ();

	#Recorremos los procesos verificando cuales tienen tiempo de llegada
	#que coincida con el tiempo actual
	foreach my $proceso(@{$self->{procesos}}) {
		if ($proceso->get_llegada() == $self->{tiempo}) {
			push @nuevos_procesos, $proceso;
		}
	}

	return @nuevos_procesos;

}

sub get_ready {
	my ($self) = @_;

	return @{$self->{ready}};
}

sub get_wait_first {
	my ($self) = @_;

	return @{$self->{wait_first}};
}

sub get_wait_second {
	my ($self) = @_;

	return @{$self->{wait_second}};
}

sub get_wait_third {
	my ($self) = @_;

	return @{$self->{wait_third}};
}


1;
