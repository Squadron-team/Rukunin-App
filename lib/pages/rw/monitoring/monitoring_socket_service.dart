import 'dart:async';
import 'dart:math';

class MonitoringSocketService {
  final _controller = StreamController<List<Map<String, dynamic>>>.broadcast();
  Timer? _timer;

  Stream<List<Map<String, dynamic>>> get stream => _controller.stream;

  void connect() {
    _timer = Timer.periodic(const Duration(seconds: 2), (_) {
      final random = Random();

      _controller.add([
        {
          'rt': 'RT 01',
          'laporan': random.nextInt(15),
          'kegiatan': random.nextInt(10),
        },
        {
          'rt': 'RT 02',
          'laporan': random.nextInt(15),
          'kegiatan': random.nextInt(10),
        },
        {
          'rt': 'RT 03',
          'laporan': random.nextInt(15),
          'kegiatan': random.nextInt(10),
        },
      ]);
    });
  }

  void disconnect() {
    _timer?.cancel();
    _controller.close();
  }
}
