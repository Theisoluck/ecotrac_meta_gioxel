// Datos: contrato de la fuente de consumos. Habla como el dominio.

// Importa la entidad Consumo.
import '../dominio/consumo.dart';

// Cualquier fuente de datos (memoria, disco, nube) cumple este contrato.
abstract class ConsumoRepository {
  // Guarda un consumo.
  Future<void> guardar(Consumo consumo);

  // Regresa todos los consumos guardados, en orden.
  Future<List<Consumo>> todos();
}
