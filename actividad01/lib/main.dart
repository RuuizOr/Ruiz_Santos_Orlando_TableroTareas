import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista viva DMI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const ListaVivaPage(title: 'Equipo 10A — Lista viva'),
    );
  }
}

class ListaVivaPage extends StatefulWidget {
  const ListaVivaPage({super.key, required this.title});

  final String title;

  @override
  State<ListaVivaPage> createState() => _ListaVivaPageState();
}

class _ListaVivaPageState extends State<ListaVivaPage> {
  final List<String> _nombres = ['Alexa', 'Diego', 'Rocío', 'Adrián', 'Antonio'];
  final List<int> _puntos = [0, 0, 0, 0, 0];

  void _sumar(int index) {
    setState(() {
      _puntos[index]++;
    });
  }

  void _restar(int index) {
    setState(() {
      if (_puntos[index] > 0) {
        _puntos[index]--;
      }
    });
  }

  void _agregar() {
    setState(() {
      _nombres.add('Integrante ${_nombres.length + 1}');
      _puntos.add(0);
    });
  }

  void _resetPuntos() {
    setState(() {
      for (var i = 0; i < _puntos.length; i++) {
        _puntos[i] = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final total = _puntos.fold<int>(0, (a, b) => a + b);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Poner puntos en cero',
            onPressed: _resetPuntos,
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
                    'Integrantes: ${_nombres.length}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Text(
                  'Total: $total',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              itemCount: _nombres.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text('${index + 1}'),
                    ),
                    title: Text(_nombres[index]),
                    subtitle: Text('Puntos: ${_puntos[index]}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          tooltip: 'Restar',
                          onPressed: () => _restar(index),
                          icon: const Icon(Icons.remove_circle_outline),
                        ),
                        IconButton(
                          tooltip: 'Sumar',
                          onPressed: () => _sumar(index),
                          icon: const Icon(Icons.add_circle_outline),
                        ),
                      ],
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
        icon: const Icon(Icons.person_add),
        label: const Text('Agregar'),
      ),
    );
  }
}