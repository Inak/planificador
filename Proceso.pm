#!/usr/bin/perl

package Proceso;

sub new {
	my $class = shift;

	my $self = {
		id       => shift,
		padre_id => shift,
		tipo     => shift, # 1: KLT, 2: ULT; min. 1..3 KTL, 0..3 ULT.
		llegada  => shift, # tiempo de llegada 0..120 (max cant. de ráfagas)
		rafagas  => [ @_ ],
	};

	bless $self, $class;

	return $self;
}

sub getTotalRafagas {
	my($self) = @_;
	my $totalRafagas = 0;
	# agarra el array de la instancia
	my @rafagas = @{$self->{rafagas}};
	foreach $r (@rafagas) {
		$totalRafagas += $r->{cantidad};
	}
	# devuelve la suma
	return $totalRafagas;
}

sub mostrarCampos {
	my($self) = @_;
	print "Resumen proceso:\n";
	print "id: " . $self->{id} . "\n";
	print "proceso padre: " . $self->{padre_id} . "\n";
	print "tipo de proceso: " . $self->{tipo} . "\n";
	print "tiempo de llegada: " . $self->{llegada} . "\n";
	print "rafagas: " . $self->getTotalRafagas() . "\n";
	print "\n";
}

1;
