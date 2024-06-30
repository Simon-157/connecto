import 'package:connecto/widgets/explore/map_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationExploreScreen extends StatefulWidget {
  const LocationExploreScreen({super.key});

  @override
  _LocationExploreScreenState createState() => _LocationExploreScreenState();
}

class _LocationExploreScreenState extends State<LocationExploreScreen> {
  int _selectedIndex = 1;

  static final List<LatLng> locations = [
    const LatLng(5.7603, 0.2199),
    const LatLng(5.7803, 0.2299),
    const LatLng(5.7703, 0.2399),
  ];

  static final List<Widget> _widgetOptions = <Widget>[
    const JobsWidget(),
    MapWidget(locations: locations),
    const EventsWidget(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    body: Stack(
      children: [
        IndexedStack(
          index: _selectedIndex,
          children: _widgetOptions.map((widget) {
            if (widget is MapWidget) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: widget,
                  ),
                ),
              );
            }
            return widget;
          }).toList(),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: TabBar(
              selectedIndex: _selectedIndex,
              onTap: _onItemTapped,
            ),
          ),
        ),
      ],
    ),
  );
}

}

class TabBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const TabBar({Key? key, required this.selectedIndex, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TabIcon(
            icon: Icons.work_outline,
            isSelected: selectedIndex == 0,
            onTap: () => onTap(0),
          ),
          TabIcon(
            icon: Icons.location_on_outlined,
            isSelected: selectedIndex == 1,
            onTap: () => onTap(1),
          ),
          TabIcon(
            icon: Icons.rocket_outlined,
            isSelected: selectedIndex == 2,
            onTap: () => onTap(2),
          ),
        ],
      ),
    );
  }
}

class TabIcon extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const TabIcon(
      {Key? key,
      required this.icon,
      required this.isSelected,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isSelected ? Colors.blue : Colors.grey),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 4),
              height: 2,
              width: 20,
              decoration: const BoxDecoration(
                color: Colors.blue,
                border: Border(
                  bottom: BorderSide(
                    color: Colors.blue,
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class JobsWidget extends StatelessWidget {
  const JobsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Jobs Page', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)));
  }
}

class EventsWidget extends StatelessWidget {
  const EventsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Events Page', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)));
  }
}
