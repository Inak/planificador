package HrrtUlt;
use diagnostics;

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
	my $hrrt = (($tiempo - $proc->get_llegada()) + $proc->get_rafaga_actual()) / $proc->get_rafaga_actual();
	my $hrrt_a = undef;

	foreach my $proc_a(@ready) {
		$hrrt_a = (($tiempo - $proc_a->get_llegada()) + $proc_a->get_rafaga_actual()) / $proc_a->get_rafaga_actual();
		if ($proc_a->get_padre_id() == $proc->get_padre_id() && $hrrt_a > $hrrt && $proc_a->es_ult()) {
			$hrrt = $hrrt_a;
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
