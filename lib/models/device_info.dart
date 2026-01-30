enum NetworkState {
  unknown(title: '알 수 없음'),
  offline(title: '오프라인'),
  wifi(title: 'Wi-Fi'),
  mobile(title: '모바일 테더링')
  ;

  final String title;

  const NetworkState({required this.title});
}

class DeviceInfo {
  final int? batteryLevel;
  final NetworkState network;

  DeviceInfo({this.batteryLevel, required this.network});

  DeviceInfo copyWith({
    int? batteryLevel,
    NetworkState? network,
  }) => DeviceInfo(
    batteryLevel: batteryLevel ?? this.batteryLevel,
    network: network ?? this.network,
  );
}
