// Presentación: único dueño del estado compartido de EcoTrack.

// Importa ChangeNotifier. No material.dart: el ViewModel no dibuja.
import 'package:flutter/foundation.dart';

// Importa el contrato, nunca una implementación.
import '../datos/consumo_repository.dart';
// Importa la entidad y la regla de litros.
import '../dominio/consumo.dart';
// Importa las reglas de la meta.
import '../dominio/meta.dart';

// ViewModel observable: avisa con notifyListeners() cuando cambia algo visible.
class ConsumosViewModel extends ChangeNotifier {
  // Recibe el contrato por constructor: no sabe si es memoria o nube.
  ConsumosViewModel(this._repositorio);

  // Fuente de verdad de los consumos.
  final ConsumoRepository _repositorio;

  // Estado compartido.
  List<Consumo> consumos = const [];
  String? error;
  bool guardando = false;
  double meta = metaInicial;

  // Estado derivado: se calcula cada vez, no se guarda.
  double get total => consumos.fold(0.0, (suma, c) => suma + c.litros);
  double get avance => avanceDeMeta(total: total, meta: meta);
  bool get metaSuperada => total > meta;

  // Lee lo que ya tenía el repositorio y avisa.
  Future<void> cargar() async {
    consumos = await _repositorio.todos();
    notifyListeners();
  }

  // Valida con el dominio y guarda. Regresa true si se guardó.
  Future<bool> guardar(String laboratorio, String litrosTexto) async {
    final litros = double.tryParse(litrosTexto.trim().replaceAll(',', '.'));
    final mensaje = validarLitros(litros);
    if (mensaje != null) {
      error = mensaje;
      notifyListeners();
      return false;
    }

    guardando = true;
    error = null;
    notifyListeners();

    await _repositorio.guardar(
      Consumo(laboratorio: laboratorio, litros: litros!),
    );
    consumos = await _repositorio.todos();

    guardando = false;
    notifyListeners();
    return true;
  }

  // Sube la meta un paso.
  void subirMeta() {
    meta = ajustarMeta(meta, pasoMeta);
    notifyListeners();
  }

  // Baja la meta un paso; el mínimo lo decide el dominio.
  void bajarMeta() {
    meta = ajustarMeta(meta, -pasoMeta);
    notifyListeners();
  }
}
