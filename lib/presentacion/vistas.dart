// Presentación: vistas tontas. Reciben datos y callbacks, no saben qué gestor hay arriba.

// Importa los widgets de Material.
import 'package:flutter/material.dart';

// Importa la entidad y la lista de laboratorios.
import '../dominio/consumo.dart';

// Formulario de Registro. Laboratorio y texto de litros son estado efímero.
class FormularioRegistro extends StatefulWidget {
  const FormularioRegistro({
    super.key,
    required this.error,
    required this.guardando,
    required this.alGuardar,
  });

  // Mensaje de error del dominio, o null.
  final String? error;
  // Verdadero mientras se guarda: desactiva el botón.
  final bool guardando;
  // Acción de guardar. Regresa true si se guardó.
  final Future<bool> Function(String laboratorio, String litrosTexto) alGuardar;

  @override
  State<FormularioRegistro> createState() => _FormularioRegistroState();
}

class _FormularioRegistroState extends State<FormularioRegistro> {
  // Texto del campo de litros.
  final TextEditingController _litros = TextEditingController();
  // Laboratorio elegido en el desplegable.
  String _laboratorio = laboratoriosUtez.first;

  @override
  void dispose() {
    _litros.dispose();
    super.dispose();
  }

  // Llama a alGuardar y, si se guardó, limpia el campo y avisa.
  Future<void> _guardar() async {
    final guardado = await widget.alGuardar(_laboratorio, _litros.text);
    if (!mounted || !guardado) return;
    _litros.clear();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Consumo guardado')));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        DropdownButtonFormField<String>(
          initialValue: _laboratorio,
          decoration: const InputDecoration(labelText: 'Laboratorio'),
          items: [
            for (final lab in laboratoriosUtez)
              DropdownMenuItem(value: lab, child: Text(lab)),
          ],
          onChanged: (valor) {
            if (valor != null) setState(() => _laboratorio = valor);
          },
        ),
        const SizedBox(height: 16),
        TextField(
          key: const Key('litros'),
          controller: _litros,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: 'Litros',
            errorText: widget.error,
          ),
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: widget.guardando ? null : _guardar,
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}

// Historial: total y una fila por consumo.
class ListaHistorial extends StatelessWidget {
  const ListaHistorial({
    super.key,
    required this.consumos,
    required this.total,
  });

  final List<Consumo> consumos;
  final double total;

  @override
  Widget build(BuildContext context) {
    if (consumos.isEmpty) {
      return const Center(child: Text('Sin consumos'));
    }
    return ListView(
      children: [
        ListTile(title: Text('Total: ${total.toStringAsFixed(1)} L')),
        const Divider(height: 1),
        for (final consumo in consumos)
          ListTile(
            title: Text(consumo.laboratorio),
            trailing: Text('${consumo.litros.toStringAsFixed(1)} L'),
          ),
      ],
    );
  }
}

// Panel de la meta semanal: uso, avance, estado y botones.
class PanelMeta extends StatelessWidget {
  const PanelMeta({
    super.key,
    required this.total,
    required this.meta,
    required this.avance,
    required this.metaSuperada,
    required this.alSubir,
    required this.alBajar,
  });

  final double total;
  final double meta;
  final double avance;
  final bool metaSuperada;
  final VoidCallback alSubir;
  final VoidCallback alBajar;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Usado: ${total.toStringAsFixed(1)} de ${meta.toStringAsFixed(1)} L',
        ),
        const SizedBox(height: 12),
        LinearProgressIndicator(value: avance),
        const SizedBox(height: 12),
        Text(metaSuperada ? 'Te pasaste de la meta' : 'Dentro de la meta'),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton.outlined(
              key: const Key('bajarMeta'),
              tooltip: 'Bajar meta',
              onPressed: alBajar,
              icon: const Icon(Icons.remove),
            ),
            const SizedBox(width: 16),
            IconButton.outlined(
              key: const Key('subirMeta'),
              tooltip: 'Subir meta',
              onPressed: alSubir,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ],
    );
  }
}

// Esqueleto con barra inferior. La pestaña activa es estado efímero.
class PantallasEcoTrack extends StatefulWidget {
  const PantallasEcoTrack({
    super.key,
    required this.titulo,
    required this.registro,
    required this.historial,
    required this.meta,
  });

  final String titulo;
  final Widget registro;
  final Widget historial;
  final Widget meta;

  @override
  State<PantallasEcoTrack> createState() => _PantallasEcoTrackState();
}

class _PantallasEcoTrackState extends State<PantallasEcoTrack> {
  // Pestaña visible.
  int _indice = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.titulo)),
      // IndexedStack mantiene montadas las tres pestañas y enseña una.
      body: IndexedStack(
        index: _indice,
        children: [widget.registro, widget.historial, widget.meta],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indice,
        onDestinationSelected: (i) => setState(() => _indice = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.water_drop), label: 'Registro'),
          NavigationDestination(icon: Icon(Icons.list), label: 'Historial'),
          NavigationDestination(icon: Icon(Icons.flag), label: 'Meta'),
        ],
      ),
    );
  }
}
