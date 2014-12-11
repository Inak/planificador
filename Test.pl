#!/usr/bin/perl

package Test;
use Planificador;
use Salida;
use Fifo;
use Srt;
use FifoUlt;
use SrtUlt;
use SpnUlt;
use HrrnUlt;
use RoundRobinUlt;
use Proceso;
use Rafaga;

#
# Tipos de hilo: klt => 0, ult => 1
# Tipos de rafaga: cpu => 0, i/o 1=> 1, i/o 2=> 2, i/o 3=> 3
# Id's biblioteca: 
# Fifo => 0
# RR => 1
# Hrrn => 2
# Spn => 3
# Srt => 4
#
# Datos proceso: nombre, id, padre_id (relaciona el hilo con un proceso), tipo hilo (klt o ult), tiempo llegada, Rafagas
# 
# Datos de una rafaga: tipo de rafaga, cantidad
#

$procesos = [new Proceso("P1(KLT1)", 1, 1, 0, 0, @{[new Rafaga(0, 4), new Rafaga(1, 1), new Rafaga(0, 3), new Rafaga(3, 2)]}),
                        new Proceso("P2(KLT1)", 2, 2, 0, 2, @{[new Rafaga(0, 2), new Rafaga(1, 3), new Rafaga(0, 2)]}),
                        new Proceso("P2(ULT1)", 3, 2, 1, 2, @{[new Rafaga(0, 3), new Rafaga(2, 2), new Rafaga(0, 2)]}),
			new Proceso("P3(KLT1)", 4, 4, 0, 4, @{[new Rafaga(0, 2), new Rafaga(0, 2), new Rafaga(3, 1), new Rafaga(0, 1)]}),
                        new Proceso("P3(ULT1)", 5, 4, 1, 4, @{[new Rafaga(0, 3), new Rafaga(2, 1), new Rafaga(0, 2), new Rafaga(1, 1)]}),
                        new Proceso("P3(ULT2)", 6, 4, 1, 4, @{[new Rafaga(0, 1), new Rafaga(0, 2), new Rafaga(2, 2), new Rafaga(0, 2)]})];                         





$salida = new Salida();
$salida->inicializar(@{$procesos});
$planificador = new Planificador(new Srt(new FifoUlt(0)), 1, $salida, @{$procesos});
$planificador->planificar_procesos();


$salida->mostrar_historico();

1;




