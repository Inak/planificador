package FifoUlt;
use diagnostics;

sub new {
	my $class = shift;

	my $self = {
		id => shift,
	};

	bless($self, $class);
	return $self;
}


sub proximo_proceso {
	my ($self, $proc, $tiempo, @ready) = @_;
	my $encontrado = 0;
	my $cont = 0;
	my $proc_actual = $proc;
	
	while (!$encontrado) {
		if ($ready[$cont]->get_padre_id() == $proc->get_padre_id() && $ready[$cont]->es_ult()) {
			$proc_actual = $ready[$cont];
			$encontrado = 1;
		}
		$cont = $cont + 1;
	}
	
	return $proc_actual;
}

sub get_id {
	my ($self) = @_;

	return $self->{id};
}

1;
