import 'package:flutter/material.dart';
import 'package:glic_note/modules/history/pages/history_page.dart';
import 'package:glic_note/modules/profile/pages/profile_page.dart';
import 'package:glic_note/modules/records/pages/record_form_page.dart';

class MainScaffold extends StatefulWidget {
  final int initialIndex;
  const MainScaffold({super.key, this.initialIndex = 1});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  static const _dropColor = Color(0xFFC83737);
  static const _bgColor = Colors.white;

  final List<Widget> _pages = const [
    HistoryPage(),
    RecordFormPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: _bgColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: _bgColor,
          currentIndex: _currentIndex,
          selectedItemColor: _dropColor,
          unselectedItemColor: Colors.grey.shade600,
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          onTap: (index) => setState(() => _currentIndex = index),
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'Histórico',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.add_circle,
                size: 36,
                color: _dropColor,
              ),
              label: 'Novo',
            ),
            const BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                size: 36,
                color: _dropColor,
              ),
              label: 'Perfil',
            ),
          ],
        ),
      ),
    );
  }
}
