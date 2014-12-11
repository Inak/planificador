package Fifo;
use Proceso;
use Rafaga;
use FifoUlt;
use SrtUlt;
use SpnUlt;
use RoundRobinUlt;
use HrrnUlt;
use diagnostics;

sub new {
	my $class = shift;
	
	my $self = {
		biblioteca => shift,
		my_ready => [],
		my_wait_first => [],
		my_wait_second => [],
		my_wait_third => [],
		salida => undef,
	};

	bless($self, $class);
    return $self;
}

sub proximo_proceso {
	my ($self, $tiempo, @ready) = @_;
	my $proc_actual = new Proceso("",-1, -1);

	if (scalar (@ready) > 0) {
		$proc_actual = $ready[0];
		
		if ($proc_actual->es_ult()) {
			
			$proc_actual = $self->{biblioteca}->proximo_proceso($proc_actual, $tiempo, @ready);
		}
	}
	return $proc_actual;
}

sub procesar {
	my ($self, $proc_actual) = @_;
	
	$proc_actual->descontar_rafaga();
	$self->{salida}->set_proceso($proc_actual);
	$self->controlar_proceso($proc_actual);
}

sub controlar_proceso {
	my ($self, $proc) = @_;
	my @foo_aux;
	my @foo_aux_2;

	if ($proc->get_rafaga_actual() == 0) {
		$proc->eliminar_rafaga_actual();
		if ($proc->proceso_con_rafagas()) {
			if (!$self->ready_to_ready($proc)) {
				$self->ready_to_wait($proc);
			}
		} else {
			@{$self->{my_ready}} = $self->borrar_proceso($proc);
		}
	} elsif ($self->{biblioteca}->get_id() == 1 && $proc->get_quantos() == 0 && $proc->es_ult()) {
		@{$self->{my_ready}} = $self->borrar_proceso($proc);
		@foo_aux = $self->get_process_ult($proc, @{$self->{my_ready}});
		@foo_aux_2 = $self->get_process_not_rel($proc, @{$self->{my_ready}});

		push @foo_aux, $proc;
		foreach my $p(@foo_aux_2) {
			push @foo_aux, $p;
		}

		@{$self->{my_ready}} = @foo_aux;
	}

}

sub ready_to_ready {
	my ($self, $proc) = @_;
	my $ready_again = 0;

	if ($proc->rafaga_cpu()) {
		@{$self->{my_ready}} = $self->borrar_proceso($proc);
		push @{$self->{my_ready}}, $proc;
		$ready_again = 1;
	}
	
	return $ready_again;
}

sub ready_to_wait {
	my ($self, $proc) = @_;
	my @ready_aux = ();
	my @ready_aux_2 = ();

	if ($proc->rafaga_wait_first()) {
		@ready_aux = $self->borrar_proceso($proc);
		push @{$self->{my_wait_first}}, $proc;
	} elsif ($proc->rafaga_wait_second()) {
		@ready_aux = $self->borrar_proceso($proc);
		push @{$self->{my_wait_second}}, $proc;
	} elsif ($proc->rafaga_wait_third()) {
		@ready_aux = $self->borrar_proceso($proc);
		push @{$self->{my_wait_third}}, $proc;
	}

	if ($proc->es_ult()) {
		foreach my $proc_f(@ready_aux) {
			if ($proc->get_padre_id() == $proc_f->get_padre_id() && $proc_f->es_ult()) {
				if ($proc->rafaga_wait_first()) {
					push @{$self->{my_wait_first}}, $proc_f;
				} elsif ($proc->rafaga_wait_second()) {
					push @{$self->{my_wait_second}}, $proc_f;
				} elsif ($proc->rafaga_wait_third()) {
					push @{$self->{my_wait_third}}, $proc_f;
				}
			} else {
				push @ready_aux_2, $proc_f;
			}
		}
		@ready_aux = @ready_aux_2;
	}

	@{$self->{my_ready}} = @ready_aux;
}

sub borrar_proceso {
	my ($self, $proc) = @_;
	my @ready_aux = ();

	foreach my $proc_a(@{$self->{my_ready}}) {
		if ($proc_a->get_id() != $proc->get_id()) {
			push @ready_aux, $proc_a;
		}
	}

	return @ready_aux;
}

sub get_ready {
	my ($self) = @_;

	return @{$self->{my_ready}};
}

sub set_ready {
	my ($self, @ready) = @_;
	
	@{$self->{my_ready}} = @ready;
}

sub get_wait_first {
	my ($self) = @_;

	return @{$self->{my_wait_first}};
}

sub set_wait_first {
	my ($self, @wait_first) = @_;
	
	@{$self->{my_wait_first}} = @wait_first;
}

sub get_wait_second {
	my ($self) = @_;

	return @{$self->{my_wait_second}};
}

sub set_wait_second {
	my ($self, @wait_second) = @_;
	
	@{$self->{my_wait_second}} = @wait_second;
}

sub get_wait_third {
	my ($self) = @_;

	return @{$self->{my_wait_third}};
}

sub set_wait_third {
	my ($self, @wait_third) = @_;

	@{$self->{my_wait_third}} = @wait_third;
}

sub set_salida {
	my ($self, $salida) = @_;
	
	$self->{salida} = $salida;
}

sub get_process_ult {
	my ($self, $proc, @foo_p) = @_;
	my @foo_aux = ();

	foreach my $proc_a(@foo_p) {
		if ($proc->get_padre_id() == $proc_a->get_padre_id() && $proc_a->es_ult()) {
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


1;
