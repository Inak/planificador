package Proceso;

my @estado = (
	"listo",
	"ejecutando",
	"bloqueado",
	"finalizado"
);

sub new {
	my $class = shift;
	my $self = {
		_id => shift,
		_nombre => shift,
		_estado => shift,
	};
	bless $self, $class;
	return $self;
}

# array de los procesos que van a ser planificados
# TODO: ingresar procesos! validar!
my @procesos = (
	{ id: 1, nombre: "Calculadora", estado: @estado[0] },
	{ id: 2, nombre: "Paint", estado: @estado[0] },
	{ id: 3, nombre: "Chrome", estado: @estado[0] },
	{ id: 4, nombre: "Terminal", estado: @estado[0] },
	{ id: 5, nombre: "Sublime Text 2", estado: @estado[0] },
	{ id: 6, nombre: "LibreOffice Writer", estado: @estado[0] },
	{ id: 7, nombre: "Files", estado: @estado[0] },
	{ id: 8, nombre: "Rhythmbox Music Player", estado: @estado[0] },
	{ id: 9, nombre: "Image Viewer", estado: @estado[0] },
	{ id: 10, nombre: "Firefox", estado: @estado[0] }
);

1;