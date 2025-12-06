import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:rukunin/widgets/loading_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui_web' as ui_web;
import 'package:web/web.dart' as web;

class GuideScreen extends StatefulWidget {
  const GuideScreen({super.key});

  @override
  State<GuideScreen> createState() => _GuideScreenState();
}

class _GuideScreenState extends State<GuideScreen> {
  late final WebViewController? _controller;
  bool _isLoading = true;

  // TODO: Replace with the actual URL!
  static const String _guideUrl = 'https://example.com';
  static const String _iframeViewType = 'guide-iframe';

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _initializeIFrame();
    } else {
      _initializeWebView();
    }
  }

  void _initializeIFrame() {
    // Register the IFrame view factory for web
    ui_web.platformViewRegistry.registerViewFactory(_iframeViewType, (
      int viewId,
    ) {
      final iframe = web.HTMLIFrameElement()
        ..src = _guideUrl
        ..style.border = 'none'
        ..style.height = '100%'
        ..style.width = '100%';

      iframe.onLoad.listen((event) {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      });

      iframe.onError.listen((event) {
        if (mounted) {
          setState(() => _isLoading = false);
          _showErrorSnackBar('Gagal memuat halaman');
        }
      });

      return iframe;
    });
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() => _isLoading = true);
          },
          onPageFinished: (String url) {
            setState(() => _isLoading = false);
          },
          onWebResourceError: (WebResourceError error) {
            _showErrorSnackBar('Gagal memuat halaman: ${error.description}');
          },
        ),
      )
      ..loadRequest(Uri.parse(_guideUrl));
  }

  Future<void> _launchUrlInBrowser() async {
    final uri = Uri.parse(_guideUrl);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        _showErrorSnackBar('Tidak dapat membuka URL');
      }
    }
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Panduan Pengguna',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              if (kIsWeb) {
                // Reload the current page to refresh the iframe
                setState(() {
                  _isLoading = true;
                });
                // Trigger a rebuild to reload iframe
                Future.delayed(const Duration(milliseconds: 100), () {
                  if (mounted) {
                    setState(() {});
                  }
                });
              } else {
                _controller?.reload();
              }
            },
          ),
          if (kIsWeb)
            IconButton(
              icon: const Icon(Icons.open_in_new),
              tooltip: 'Buka di tab baru',
              onPressed: _launchUrlInBrowser,
            ),
        ],
      ),
      body: Stack(
        children: [
          kIsWeb
              ? const HtmlElementView(viewType: _iframeViewType)
              : WebViewWidget(controller: _controller!),
          if (_isLoading) const Center(child: LoadingIndicator()),
        ],
      ),
    );
  }
}
