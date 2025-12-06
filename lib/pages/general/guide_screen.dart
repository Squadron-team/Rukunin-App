import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:rukunin/widgets/loading_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:rukunin/pages/general/guide_screen_stub.dart'
    if (dart.library.html) 'guide_screen_web.dart';

class GuideScreen extends StatefulWidget {
  const GuideScreen({super.key});

  @override
  State<GuideScreen> createState() => _GuideScreenState();
}

class _GuideScreenState extends State<GuideScreen> {
  WebViewController? _controller;
  bool _isLoading = true;

  // TODO: Replace with the actual URL!
  static const String _guideUrl = 'https://example.com';
  static const String _iframeViewType = 'guide-iframe';
  bool _iframeRegistered = false;

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
    if (!_iframeRegistered) {
      registerIFrameViewFactory(_iframeViewType, _guideUrl);
      _iframeRegistered = true;
    }
    // Simulate loading completion for web
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    });
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            if (mounted) {
              setState(() => _isLoading = true);
            }
          },
          onPageFinished: (String url) {
            if (mounted) {
              setState(() => _isLoading = false);
            }
          },
          onWebResourceError: (WebResourceError error) {
            if (mounted) {
              _showErrorSnackBar('Gagal memuat halaman: ${error.description}');
            }
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

  void _reloadContent() {
    if (kIsWeb) {
      setState(() {
        _isLoading = true;
        _iframeRegistered = false;
      });
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          _initializeIFrame();
        }
      });
    } else {
      _controller?.reload();
    }
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
            onPressed: _reloadContent,
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
          if (kIsWeb)
            const HtmlElementView(viewType: _iframeViewType)
          else
            WebViewWidget(controller: _controller!),
          if (_isLoading) const Center(child: LoadingIndicator()),
        ],
      ),
    );
  }
}
