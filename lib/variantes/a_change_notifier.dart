// Variante A: ChangeNotifier puro. El ViewModel viaja por constructor.

// Importa los widgets de Material.
import 'package:flutter/material.dart';

// Importa el contrato del repositorio.
import '../datos/consumo_repository.dart';
// Importa el ViewModel.
import '../presentacion/consumos_view_model.dart';
// Importa las vistas tontas.
import '../presentacion/vistas.dart';

// Raíz de la variante A. Es StatefulWidget para crear el ViewModel una sola vez.
class AppChangeNotifier extends StatefulWidget {
  const AppChangeNotifier({super.key, required this.repositorio});

  final ConsumoRepository repositorio;

  @override
  State<AppChangeNotifier> createState() => _AppChangeNotifierState();
}

class _AppChangeNotifierState extends State<AppChangeNotifier> {
  // Único ViewModel de la app: lo crea y lo libera este State.
  late final ConsumosViewModel _vm = ConsumosViewModel(widget.repositorio);

  @override
  void initState() {
    super.initState();
    _vm.cargar();
  }

  @override
  void dispose() {
    _vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoTrack Meta',
      theme: ThemeData(colorSchemeSeed: Colors.green),
      home: PantallasEcoTrack(
        titulo: 'A · ChangeNotifier',
        registro: RegistroCN(vm: _vm),
        historial: HistorialCN(vm: _vm),
        meta: MetaCN(vm: _vm),
      ),
    );
  }
}

// Adaptador de Registro: escucha al ViewModel y alimenta la vista tonta.
class RegistroCN extends StatelessWidget {
  const RegistroCN({super.key, required this.vm});

  final ConsumosViewModel vm;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: vm,
      builder: (context, _) => FormularioRegistro(
        error: vm.error,
        guardando: vm.guardando,
        alGuardar: vm.guardar,
      ),
    );
  }
}

// Adaptador de Historial.
class HistorialCN extends StatelessWidget {
  const HistorialCN({super.key, required this.vm});

  final ConsumosViewModel vm;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: vm,
      builder: (context, _) =>
          ListaHistorial(consumos: vm.consumos, total: vm.total),
    );
  }
}

// Adaptador de Meta.
class MetaCN extends StatelessWidget {
  const MetaCN({super.key, required this.vm});

  final ConsumosViewModel vm;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: vm,
      builder: (context, _) => PanelMeta(
        total: vm.total,
        meta: vm.meta,
        avance: vm.avance,
        metaSuperada: vm.metaSuperada,
        alSubir: vm.subirMeta,
        alBajar: vm.bajarMeta,
      ),
    );
  }
}
