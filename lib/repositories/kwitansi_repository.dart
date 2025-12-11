import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class KwitansiTemplate {
  final String id;
  final String? logoPath; // local path or null
  final String title;
  final String numberFormat;
  final String rw;
  final String rt;
  final String treasurerName;
  final String? signaturePath;
  final String footerNote;

  KwitansiTemplate({
    required this.id,
    required this.title,
    required this.numberFormat,
    required this.rw,
    required this.rt,
    required this.treasurerName,
    required this.footerNote,
    this.logoPath,
    this.signaturePath,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'logoPath': logoPath,
    'title': title,
    'numberFormat': numberFormat,
    'rw': rw,
    'rt': rt,
    'treasurerName': treasurerName,
    'signaturePath': signaturePath,
    'footerNote': footerNote,
  };

  factory KwitansiTemplate.fromJson(Map<String, dynamic> j) => KwitansiTemplate(
    id: j['id'] as String,
    logoPath: j['logoPath'] as String?,
    title: j['title'] as String? ?? '',
    numberFormat: j['numberFormat'] as String? ?? '',
    rw: j['rw'] as String? ?? '',
    rt: j['rt'] as String? ?? '',
    treasurerName: j['treasurerName'] as String? ?? '',
    signaturePath: j['signaturePath'] as String?,
    footerNote: j['footerNote'] as String? ?? '',
  );
}

class KwitansiRepository {
  static const _kKey = 'kwitansi_templates_v1';
  static KwitansiRepository? _instance;

  KwitansiRepository._();

  factory KwitansiRepository() {
    _instance ??= KwitansiRepository._();
    return _instance!;
  }

  Future<void> saveTemplate(KwitansiTemplate t) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kKey);
    List<Map<String, dynamic>> list = [];
    if (raw != null && raw.isNotEmpty) {
      try {
        final s = jsonDecode(raw) as List<dynamic>;
        list = s.map((e) => Map<String, dynamic>.from(e)).toList();
      } catch (_) {
        list = [];
      }
    }
    // replace if exists
    list.removeWhere((e) => e['id'] == t.id);
    list.add(t.toJson());
    await prefs.setString(_kKey, jsonEncode(list));
  }

  Future<List<KwitansiTemplate>> getTemplates() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final s = jsonDecode(raw) as List<dynamic>;
      return s
          .map((e) => KwitansiTemplate.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<KwitansiTemplate?> getTemplateById(String id) async {
    final all = await getTemplates();
    try {
      return all.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }
}
