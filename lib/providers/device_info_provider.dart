import 'dart:async';

import 'package:device_info_poc_app/models/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

final appProvider = DeviceInfoProvider();

class DeviceInfoProvider {

  final ValueNotifier<int> updateCount = ValueNotifier(0);

  void updateScreen() => updateCount.value = updateCount.value + 1;

  static const MethodChannel _batteryChannel = MethodChannel('com.example.device_info_poc_app/battery');
  static const EventChannel _networkChannel = EventChannel('com.example.device_info_poc_app/network');

  DeviceInfo state = DeviceInfo(
    batteryLevel: null,
    network: NetworkState.unknown,
  );

  StreamSubscription? networkSubscription;

  void initializeProvider() async {
    networkSubscription = _networkChannel.receiveBroadcastStream().listen((event) {
      state = state.copyWith(network: parseNetwork(event));
      updateScreen();
    });
    refreshBattery();
  }

  void refreshBattery() async {
    final level = await _batteryChannel.invokeMethod<int>('getBatteryLevel');
    state = state.copyWith(batteryLevel: level);
    updateScreen();
  }

  NetworkState parseNetwork(dynamic event) {
    try {
      return switch (event as String) {
        'wifi' => NetworkState.wifi,
        'mobile' => NetworkState.mobile,
        'offline' => NetworkState.offline,
        _ => NetworkState.unknown
      };
    } catch (e) {
      return NetworkState.unknown;
    }
  }
}