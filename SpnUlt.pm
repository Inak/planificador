package SpnUlt;

sub new {
	my $class = shift;
	
	my $self = {
		id =>shift,
	};
	
	bless($self, $class);
	return $self;
}

sub proximo_proceso {
	my ($self, $proc, $tiempo, @ready) = @_;
	my $proc_actual = $proc;

	foreach my $proc_a(@ready) {
		if ($proc_a->get_padre_id() == $proc->get_padre_id() && $proc_a->es_ult()
			&& $proc_a->get_rafaga_actual() < $proc->get_rafaga_actual()) {
			$proc_actual = $proc_a;
		}
	}

	return $proc_actual;
}

sub get_id {
	my ($self) = @_;

	return $self->{id};
}

1;
