// Dominio: entidad y regla de litros en Dart puro, sin Flutter.

// Laboratorios donde se registra consumo. Es una constante, no estado.
const List<String> laboratoriosUtez = ['Lab Química', 'Lab Redes', 'Lab Física'];

// Un consumo de agua registrado en un laboratorio.
class Consumo {
  // Constructor constante: un consumo no cambia después de crearse.
  const Consumo({required this.laboratorio, required this.litros});

  // Laboratorio donde se registró.
  final String laboratorio;
  // Litros consumidos.
  final double litros;
}

// Regresa el mensaje de error o null si los litros son válidos.
String? validarLitros(double? litros) {
  if (litros == null) return 'Escribe los litros con número';
  if (litros <= 0) return 'Los litros deben ser mayores que cero';
  if (litros > 10000) return 'Los litros superan el tope de 10000';
  return null;
}
