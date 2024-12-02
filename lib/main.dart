import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi Aplicación',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Monitor de Salud'),
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
  int _selectedIndex = 0;
  bool isBLEConnected = false;
  bool isGPSActive = false;
  Timer? _timer;

  // Variables para estadísticas
  String heartRate = '0';
  String steps = '0';
  String temperature = '0.0';
  String oxygen = '0';

  // Notificaciones
  int notificationCount = 0;
  List<String> notifications = [];

  @override
  void initState() {
    super.initState();
    _loadSavedData();
    _startDataUpdates();
    _checkConnections();
  }

  // Cargar datos guardados
  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      steps = prefs.getString('steps') ?? '0';
      // Cargar otros datos guardados...
    });
  }

  // Guardar datos
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('steps', steps);
    // Guardar otros datos...
  }

  // Simulación de actualizaciones periódicas
  void _startDataUpdates() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _updateHealthData();
    });
  }

  // Actualizar datos de salud (simulado)
  void _updateHealthData() {
    setState(() {
      // Simulación de datos actualizados
      heartRate = (60 + DateTime.now().second % 40).toString();
      int currentSteps = int.parse(steps);
      currentSteps += 10;
      steps = currentSteps.toString();
      temperature =
          (36.0 + (DateTime.now().minute % 15) / 10).toStringAsFixed(1);
      oxygen = (95 + DateTime.now().second % 5).toString();

      _saveData(); // Guardar datos actualizados
    });
  }

  // Verificar conexiones
  Future<void> _checkConnections() async {
    // Aquí irían las verificaciones reales de BLE y GPS
    setState(() {
      isBLEConnected = true; // Simulado
      isGPSActive = true; // Simulado
    });
  }

  // Manejar notificaciones
  void _addNotification(String message) {
    setState(() {
      notifications.insert(0, message);
      notificationCount++;
    });
  }

  void _showNotifications(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Notificaciones'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(notifications[index]),
                  leading: const Icon(Icons.notification_important),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  notifications.clear();
                  notificationCount = 0;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Limpiar todo'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  // Mostrar configuración
  void _showSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Configuración'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                SwitchListTile(
                  title: const Text('Notificaciones'),
                  value: true, // Conectar con preferencias reales
                  onChanged: (bool value) {
                    // Implementar cambio de configuración
                  },
                ),
                SwitchListTile(
                  title: const Text('Modo oscuro'),
                  value: false, // Conectar con preferencias reales
                  onChanged: (bool value) {
                    // Implementar cambio de tema
                  },
                ),
                // Más opciones de configuración...
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  // Actualizar datos manualmente
  Future<void> _refreshData() async {
    _addNotification('Actualizando datos...');
    await _checkConnections();
    _updateHealthData();
    _addNotification('Datos actualizados correctamente');
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
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () => _showNotifications(context),
              ),
              if (notificationCount > 0)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                    ),
                    child: Text(
                      '$notificationCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showSettings(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
            const SizedBox(height: 20),
            const Text(
              'Estadísticas',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: StatsCard(
                    title: 'Ritmo Cardíaco',
                    value: heartRate,
                    unit: 'BPM',
                    icon: Icons.favorite,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: StatsCard(
                    title: 'Pasos',
                    value: steps,
                    unit: 'pasos',
                    icon: Icons.directions_walk,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: StatsCard(
                    title: 'Temperatura',
                    value: temperature,
                    unit: '°C',
                    icon: Icons.thermostat,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: StatsCard(
                    title: 'Oxígeno',
                    value: oxygen,
                    unit: '%',
                    icon: Icons.air,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            // Aquí implementarías la navegación real entre páginas
            _addNotification('Navegando a la sección ${index + 1}');
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Estadísticas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _refreshData,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

// Las clases StatusRow y StatsCard permanecen igual...
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

class StatsCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final IconData icon;
  final Color color;

  const StatsCard({
    super.key,
    required this.title,
    required this.value,
    required this.unit,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: color,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  unit,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
