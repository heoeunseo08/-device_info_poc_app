import 'package:device_info_poc_app/providers/device_info_provider.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      appProvider.initializeProvider();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: .all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('BATTERY: ${appProvider.state.batteryLevel ?? "_"} %'),
            SizedBox(height: 20),
            Text('NETWORK: ${appProvider.state.network}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                appProvider.refreshBattery();
              },
              child: Text('배터리 정보 갱신'),
            ),
          ],
        ),
      ),
    );
  }
}
