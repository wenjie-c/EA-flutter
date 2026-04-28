import 'package:ea_seminario_flutter/screens/tasks_screen.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'profile_screen.dart';

/**
 * Esta es la pagina principal
 */
class MainWrapperScreen extends StatefulWidget {
  const MainWrapperScreen({super.key});

  @override
  State<MainWrapperScreen> createState() => _MainWrapperScreenState();
}

class _MainWrapperScreenState extends State<MainWrapperScreen> {
  int _currentIndex = 0;

  // Claves globales para los navegadores independientes de cada pestaña
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;

        // Si hay historial en la pestaña actual, retrocederemos en ella
        final isFirstRouteInCurrentTab = !await _navigatorKeys[_currentIndex]
            .currentState!
            .maybePop();

        if (isFirstRouteInCurrentTab) {
          // Si estamos en la raíz y no es la primera pestaña, volver a la primera
          if (_currentIndex != 0) {
            setState(() {
              _currentIndex = 0;
            });
          }
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: [
            // ?
            _buildOffstageNavigator(0, const HomeScreen()),
            _buildOffstageNavigator(1, const ProfileScreen()),
            //_buildOffstageNavigator(2, const TasksScreen()),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            if (index == _currentIndex) {
              // Si tocamos la pestaña en la que ya estamos, volvemos a la raíz de esa pestaña
              _navigatorKeys[index].currentState?.popUntil(
                (route) => route.isFirst,
              );
            } else {
              setState(() {
                _currentIndex = index;
              });
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Inicio',
            ), // Label: 'Home' seria mejor, por consistencia
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
            //BottomNavigationBarItem(icon: Icon(Icons.abc), label: 'Tasks'),
          ],
        ),
      ),
    );
  }

  // Construye un navegador independiente para cada pestaña
  Widget _buildOffstageNavigator(int index, Widget rootWidget) {
    return Offstage(
      offstage: _currentIndex != index,
      child: Navigator(
        key: _navigatorKeys[index],
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(builder: (context) => rootWidget);
        },
      ),
    );
  }
}

// No se complican mucho las cosas?
// Asi ya seria suficiente y compartiriamos lo mismos datos. https://medium.com/@rk0936626/bottomnavigationbar-in-flutter-e51a1b53b402
  // final List<Widget> _screens = [
  //   Center(child: Text('Home Screen')),
  //   Center(child: Text('Search Screen')),
  //   Center(child: Text('Profile Screen')),
  // ];

