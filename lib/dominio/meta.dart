// Dominio: reglas de la meta semanal en Dart puro, sin Flutter.

// Meta con la que arranca la semana.
const double metaInicial = 100.0;
// Cuánto sube o baja la meta con cada botón.
const double pasoMeta = 10.0;
// La meta nunca baja de este valor.
const double metaMinima = 10.0;

// Suma el cambio a la meta actual sin bajar de metaMinima.
double ajustarMeta(double actual, double cambio) {
  final nueva = actual + cambio;
  return nueva < metaMinima ? metaMinima : nueva;
}

// Fracción de la meta ya usada, entre 0 y 1.
double avanceDeMeta({required double total, required double meta}) {
  if (meta <= 0) return 1;
  return (total / meta).clamp(0, 1).toDouble();
}
