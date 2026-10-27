// Variante B: provider cuelga el MISMO ViewModel en el árbol de widgets.

// Importa los widgets de Material.
import 'package:flutter/material.dart';
// Importa ChangeNotifierProvider, watch y read.
import 'package:provider/provider.dart';

// Importa el contrato del repositorio.
import '../datos/consumo_repository.dart';
// Importa el ViewModel de la etapa 3, sin cambios.
import '../presentacion/consumos_view_model.dart';
// Importa las vistas tontas.
import '../presentacion/vistas.dart';

// Raíz de la variante B. provider crea, entrega y libera el ViewModel.
class AppProvider extends StatelessWidget {
  const AppProvider({super.key, required this.repositorio});

  final ConsumoRepository repositorio;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ConsumosViewModel>(
      create: (_) => ConsumosViewModel(repositorio)..cargar(),
      child: MaterialApp(
        title: 'EcoTrack Meta',
        theme: ThemeData(colorSchemeSeed: Colors.green),
        home: const PantallasEcoTrack(
          titulo: 'B · provider',
          registro: RegistroProvider(),
          historial: HistorialProvider(),
          meta: MetaProvider(),
        ),
      ),
    );
  }
}

// Adaptador de Registro: watch para mostrar, read para actuar.
class RegistroProvider extends StatelessWidget {
  const RegistroProvider({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ConsumosViewModel>();
    return FormularioRegistro(
      error: vm.error,
      guardando: vm.guardando,
      alGuardar: (laboratorio, litrosTexto) =>
          context.read<ConsumosViewModel>().guardar(laboratorio, litrosTexto),
    );
  }
}

// Adaptador de Historial.
class HistorialProvider extends StatelessWidget {
  const HistorialProvider({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ConsumosViewModel>();
    return ListaHistorial(consumos: vm.consumos, total: vm.total);
  }
}

// Adaptador de Meta.
class MetaProvider extends StatelessWidget {
  const MetaProvider({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ConsumosViewModel>();
    return PanelMeta(
      total: vm.total,
      meta: vm.meta,
      avance: vm.avance,
      metaSuperada: vm.metaSuperada,
      alSubir: () => context.read<ConsumosViewModel>().subirMeta(),
      alBajar: () => context.read<ConsumosViewModel>().bajarMeta(),
    );
  }
}
