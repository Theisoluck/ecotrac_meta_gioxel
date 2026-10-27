// Arranque de la variante B (provider):  flutter run

// Importa runApp.
import 'package:flutter/material.dart';

// Importa la implementación en memoria. Solo main*.dart elige la fuente.
import 'datos/memoria_consumo_repository.dart';
// Importa la variante B.
import 'variantes/b_provider.dart';

void main() {
  runApp(AppProvider(repositorio: MemoriaConsumoRepository()));
}
