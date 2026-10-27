// Datos: implementación del contrato con una lista en memoria.

// Importa el contrato.
import 'consumo_repository.dart';
// Importa la entidad Consumo.
import '../dominio/consumo.dart';

// Fuente de verdad en memoria: se pierde al cerrar la app.
class MemoriaConsumoRepository implements ConsumoRepository {
  // Lista privada: solo este repositorio la modifica.
  final List<Consumo> _consumos = [];

  @override
  Future<void> guardar(Consumo consumo) async {
    _consumos.add(consumo);
  }

  // Copia no modificable para que nadie altere la lista desde fuera.
  @override
  Future<List<Consumo>> todos() async => List.unmodifiable(_consumos);
}
