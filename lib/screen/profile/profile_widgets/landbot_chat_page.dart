import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../utils/constants.dart';
import '../../../widgets/app_text.dart';

class LandBotChatPage extends StatefulWidget {
  const LandBotChatPage({super.key});

  @override
  State<LandBotChatPage> createState() => _LandBotChatPageState();
}

class _LandBotChatPageState extends State<LandBotChatPage> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..enableZoom(false)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
          },
          onWebResourceError: (WebResourceError error) {
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
              // ScaffoldMessenger.of(context).showSnackBar(
              //   SnackBar(
              //     content: Text('Error loading chat: ${error.description}'),
              //     backgroundColor: Colors.red,
              //   ),
              // );
            }
          },
        ),
      )
      ..loadRequest(
        Uri.parse(
          'https://landbot.pro/v3/H-3123424-VTUGILM9SG3VF4ID/index.html',
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode
          ? AppConstants.darkBackgroundColor
          : AppConstants.whiteBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppConstants.primaryColor,
        elevation: 0,
        foregroundColor: Colors.white,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Theme.of(context).platform == TargetPlatform.iOS
                ? CupertinoIcons.back
                : Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const AppText(
          text: 'AI Support Chat',
          size: 18,
          weight: FontWeight.bold,
          textColor: Colors.white,
        ),
        centerTitle: true,
      ),
      body: SizedBox.expand(child: WebViewWidget(controller: _controller)),
    );
  }
}
