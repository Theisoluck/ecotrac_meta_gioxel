// Arranque de la variante A:  flutter run -t lib/main_change_notifier.dart

// Importa runApp.
import 'package:flutter/material.dart';

// Importa la implementación en memoria. Solo main*.dart elige la fuente.
import 'datos/memoria_consumo_repository.dart';
// Importa la variante A.
import 'variantes/a_change_notifier.dart';

void main() {
  runApp(AppChangeNotifier(repositorio: MemoriaConsumoRepository()));
}
