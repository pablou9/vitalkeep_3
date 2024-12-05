import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monitor de Conexiones Simulado',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Monitor de Conexiones Simulado'),
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
  bool isBLEConnected = false; // Simulación del estado BLE.
  String gpsCoordinates = 'Sin datos'; // Coordenadas simuladas del GPS.
  Timer? _timer; // Temporizador para tareas periódicas.
  final Random random = Random(); // Generador aleatorio para simulación.

  @override
  void initState() {
    super.initState();
    _startSimulations();
  }

  // Inicia las simulaciones periódicas.
  void _startSimulations() {
    _simulateBLEState(); // Simula el estado BLE.
    _simulateGPSCoordinates(); // Simula las coordenadas GPS.

    // Temporizador que actualiza los estados cada 5 segundos.
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _simulateBLEState();
      _simulateGPSCoordinates();
    });
  }

  // Simula el estado de conexión BLE.
  void _simulateBLEState() {
    setState(() {
      isBLEConnected =
          random.nextBool(); // Activa/desactiva de forma aleatoria.
    });
  }

  // Simula las coordenadas GPS.
  void _simulateGPSCoordinates() {
    setState(() {
      // Genera coordenadas aleatorias dentro de un rango razonable.
      double latitude = 37.0 + random.nextDouble() * 2.0; // Latitud simulada.
      double longitude =
          -122.0 + random.nextDouble() * 2.0; // Longitud simulada.
      gpsCoordinates =
          '${latitude.toStringAsFixed(5)}, ${longitude.toStringAsFixed(5)}';
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancela el temporizador al cerrar el widget.
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StatusRow(
              icon: Icons.bluetooth,
              label: 'Conexión BLE',
              status: isBLEConnected ? 'Conectado' : 'Desconectado',
              isActive: isBLEConnected,
            ),
            const Divider(),
            GPSStatusRow(
              coordinates: gpsCoordinates,
            ),
          ],
        ),
      ),
    );
  }
}

// Widget para mostrar el estado del BLE.
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
    return Row(
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
    );
  }
}

// Widget para mostrar las coordenadas GPS simuladas.
class GPSStatusRow extends StatelessWidget {
  final String coordinates;

  const GPSStatusRow({super.key, required this.coordinates});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.location_on,
          color: Colors.blue,
        ),
        const SizedBox(width: 8),
        const Text('GPS:'),
        const Spacer(),
        Text(
          coordinates,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
