import '../pages/rt/meetings/models/meeting.dart';

class MeetingRepository {
  static final List<Meeting> _items = _generateDummy();

  static List<Meeting> all() => List<Meeting>.from(_items);

  static void add(Meeting m) => _items.insert(0, m);

  static void toggleAttend(String id) {
    final idx = _items.indexWhere((e) => e.id == id);
    if (idx == -1) return;
    final it = _items[idx];
    final became = !it.isAttending;
    it.isAttending = became;
    if (became) {
      it.attendeesCount += 1;
      if (!it.attendingRTs.contains('RT 01')) it.attendingRTs.add('RT 01');
    } else {
      it.attendeesCount = (it.attendeesCount - 1).clamp(0, 99999);
      it.attendingRTs.remove('RT 01');
    }
  }

  static List<Meeting> _generateDummy() {
    final now = DateTime.now();
    return [
      Meeting(
        id: 'rapat_1',
        title: 'Musyawarah Kebersihan Lingkungan',
        dateTime: now.subtract(const Duration(days: 2)), 
        location: 'Balai RT, Jalan Mawar No.1',
        description: '''Evaluasi menyeluruh terhadap pelaksanaan gotong royong terakhir dan pembagian jadwal piket warga, dengan tujuan meningkatkan partisipasi serta kebersihan lingkungan sekitar. Pertemuan akan membahas hambatan yang ditemui, perbaikan proses koordinasi, dan langkah-langkah lanjutan untuk menjaga area publik.
      - Meninjau hasil kegiatan gotong royong sebelumnya
      - Menyusun jadwal piket terbaru dan pembagian tugas
      - Menentukan titik prioritas untuk pembersihan dan perbaikan''',
        attendeesCount: 5,
        isAttending: false,
        attendingRTs: ['RT 01', 'RT 03'],
        createdAt: now.subtract(const Duration(days: 5)),
      ),
      Meeting(
        id: 'rapat_2',
        title: 'Pembahasan Keamanan Malam',
        dateTime: now.subtract(const Duration(days: 1)), 
        location: 'Balai RT, Jalan Melati No.2',
        description: '''Pembahasan strategi meningkatkan keamanan lingkungan pada jam malam melalui penjadwalan ronda, pembentukan pos keamanan, dan koordinasi antar RT. Tujuan rapat ini adalah memperkecil risiko gangguan keamanan serta meningkatkan rasa aman warga melalui peran serta aktif komunitas.
      - Menetapkan jadwal ronda dan pembagian regu
      - Koordinasi antar-pos keamanan dan mekanisme pelaporan
      - Pembahasan kebutuhan peralatan dan sosialisasi warga''',
        attendeesCount: 8,
        isAttending: false,
        attendingRTs: ['RT 02'],
        createdAt: now.subtract(const Duration(days: 3)),
      ),
      Meeting(
        id: 'rapat_3',
        title: 'Rapat Pengurus RT',
        dateTime: now, // hari ini
        location: 'Balai RT, Jalan Kenanga No.5',
        description: '''Rapat internal pengurus RT untuk merencanakan dan membagi tugas persiapan acara warga mendatang. Fokus pada pembagian tanggung jawab, penyusunan timeline, serta identifikasi kebutuhan logistik agar acara dapat berjalan lancar dan aman.
      - Menyusun rundown acara dan penanggung jawab tiap sesi
      - Menentukan kebutuhan logistik dan anggaran sementara
      - Koordinasi dengan pihak terkait (keamanan, kebersihan, konsumsi)''',
        attendeesCount: 4,
        isAttending: false,
        attendingRTs: ['RT 01', 'RT 02'],
        createdAt: now.subtract(const Duration(hours: 6)),
      ),
      Meeting(
        id: 'rapat_4',
        title: 'Rapat Koordinasi Acara',
        dateTime: now.add(const Duration(days: 1)), 
        location: 'Balai RT, Jalan Kenanga No.5',
        description: '''Koordinasi akhir menjelang pelaksanaan acara warga minggu depan, termasuk finalisasi susunan acara, konfirmasi vendor, dan pembagian tugas pada hari-H. Rapat ini memastikan semua aspek operasional siap dan penugasan jelas.
      - Finalisasi rundown dan penugasan panitia
      - Konfirmasi ketersediaan fasilitas dan vendor
      - Persiapan mitigasi risiko dan rencana darurat''',
        attendeesCount: 2,
        isAttending: false,
        attendingRTs: [],
        createdAt: now,
      ),
      Meeting(
        id: 'rapat_5',
        title: 'Rapat Anggaran RT',
        dateTime: now.add(const Duration(days: 2)),
        location: 'Balai RT, Jalan Mawar No.1',
        description: '''Diskusi terperinci mengenai perencanaan anggaran RT dan alokasi iuran warga untuk perbaikan fasilitas umum. Agenda mencakup prioritas perbaikan, estimasi biaya, dan mekanisme transparansi penggunaan dana.
      - Menetapkan prioritas perbaikan fasilitas
      - Menyusun estimasi biaya dan sumber pendanaan
      - Menentukan mekanisme pelaporan penggunaan anggaran''',
        attendeesCount: 3,
        isAttending: false,
        attendingRTs: [],
        createdAt: now,
      ),
      Meeting(
        id: 'rapat_6',
        title: 'Rapat Warga Bulanan',
        dateTime: now.add(const Duration(days: 7)), 
        location: 'Balai RT, Jalan Melati No.2',
        description: '''Rapat rutin bulanan yang membahas rangkuman kegiatan selama periode sebelumnya, laporan keuangan, serta rencana kerja berikutnya. Diharapkan menghasilkan keputusan operasional dan tindak lanjut yang jelas untuk bulan mendatang.
      - Penyampaian laporan kegiatan dan keuangan bulanan
      - Evaluasi program berjalan dan usulan kegiatan baru
      - Penetapan agenda prioritas untuk bulan berikutnya''',
        attendeesCount: 0,
        isAttending: false,
        attendingRTs: [],
        createdAt: now,
      ),
    ];
  }
}
