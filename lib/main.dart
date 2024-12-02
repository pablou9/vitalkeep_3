import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monitor de Conexiones',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Monitor de Conexiones'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isBLEConnected = false;
  bool isGPSActive = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startConnectionChecks();
  }

  void _startConnectionChecks() {
    _checkConnections();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _checkConnections();
    });
  }

  Future<void> _checkConnections() async {
    // Aquí irían las verificaciones reales de BLE y GPS
    setState(() {
      isBLEConnected = true; // Simulado
      isGPSActive = true; // Simulado
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Estado del Dispositivo',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                StatusRow(
                  icon: Icons.bluetooth,
                  label: 'Conexión BLE',
                  status: isBLEConnected ? 'Conectado' : 'Desconectado',
                  isActive: isBLEConnected,
                ),
                const Divider(),
                StatusRow(
                  icon: Icons.location_on,
                  label: 'GPS',
                  status: isGPSActive ? 'Activo' : 'Inactivo',
                  isActive: isGPSActive,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _checkConnections,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

class StatusRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String status;
  final bool isActive;

  const StatusRow({
    super.key,
    required this.icon,
    required this.label,
    required this.status,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: isActive ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 8),
          Text(label),
          const Spacer(),
          Text(
            status,
            style: TextStyle(
              color: isActive ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
