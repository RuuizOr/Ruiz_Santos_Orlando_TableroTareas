import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tablero de tareas',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const TableroPage(title: 'Tareas'),
    );
  }
}

class Tarea {
  String titulo;
  bool completada;

  Tarea({required this.titulo, this.completada = false});
}

class TableroPage extends StatefulWidget {
  const TableroPage({super.key, required this.title});

  final String title;

  @override
  State<TableroPage> createState() => _TableroPageState();
}

class _TableroPageState extends State<TableroPage> {
  final List<Tarea> _tareas = [
    Tarea(titulo: 'Subir captura de la lista viva'),
    Tarea(titulo: 'Responder autoevaluación'),
    Tarea(titulo: 'Tarea 3'),
  ];


  bool _soloPendientes = false;
  int _siguiente = 4;

  // Marca o desmarca usando el índice REAL de _tareas
  void _alternar(int indiceReal) {
    setState(() {
      _tareas[indiceReal].completada = !_tareas[indiceReal].completada;
    });
  }

  void _eliminar(int indiceReal) {
    setState(() {
      _tareas.removeAt(indiceReal);
    });
  }

  void _agregar() {
    setState(() {
      _tareas.add(Tarea(titulo: 'Tarea $_siguiente'));
      _siguiente++;
    });
  }

  void _cambiarFiltro(bool valor) {
    setState(() {
      _soloPendientes = valor;
    });
  }

  void _resetTareas() {
    setState(() {
      for (final tarea in _tareas) {
        tarea.completada = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final completadas = _tareas.where((t) => t.completada).length;

    // Si el filtro está activo, solo entran las pendientes.
    final indicesVisibles = <int>[
      for (var i = 0; i < _tareas.length; i++)
        if (!_soloPendientes || !_tareas[i].completada) i,
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Desmarcar todas',
            onPressed: _resetTareas,
            icon: const Icon(Icons.restart_alt),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Completadas: $completadas / ${_tareas.length}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Text('Solo pendientes'),
                const SizedBox(width: 8),
                Switch(
                  value: _soloPendientes,
                  onChanged: _cambiarFiltro,
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: indicesVisibles.isEmpty
                ? Center(
              child: Text(
                _soloPendientes
                    ? 'No hay tareas pendientes'
                    : 'No hay tareas',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            )
                : ListView.builder(
              itemCount: indicesVisibles.length,
              itemBuilder: (context, index) {
                final indiceReal = indicesVisibles[index];
                final tarea = _tareas[indiceReal];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: Checkbox(
                      value: tarea.completada,
                      onChanged: (_) => _alternar(indiceReal),
                    ),
                    title: Text(
                      tarea.titulo,
                      style: TextStyle(
                        decoration: tarea.completada
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        color: tarea.completada ? Colors.grey : null,
                      ),
                    ),
                    trailing: IconButton(
                      tooltip: 'Eliminar',
                      onPressed: () => _eliminar(indiceReal),
                      icon: const Icon(Icons.delete_outline),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _agregar,
        icon: const Icon(Icons.add_task),
        label: const Text('Agregar'),
      ),
    );
  }
}