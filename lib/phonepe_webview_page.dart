import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'services/phonepe_service.dart';

class PhonePeWebViewPage extends StatefulWidget {
  final String paymentUrl;
  final String merchantTransactionId;
  final String callbackUrl;
  final double amount;

  const PhonePeWebViewPage({
    super.key,
    required this.paymentUrl,
    required this.merchantTransactionId,
    required this.callbackUrl,
    required this.amount,
  });

  @override
  State<PhonePeWebViewPage> createState() => _PhonePeWebViewPageState();
}

class _PhonePeWebViewPageState extends State<PhonePeWebViewPage> {
  late WebViewController _controller;
  bool _isLoading = true;
  String _loadingMessage = 'Loading PhonePe payment page...';

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (progress < 100) {
              setState(() {
                _isLoading = true;
                _loadingMessage = 'Loading... ${progress}%';
              });
            } else {
              setState(() {
                _isLoading = false;
              });
            }
          },
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
              _loadingMessage = 'Loading payment page...';
            });
            _handleUrlChange(url);
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              _isLoading = false;
            });
            _showErrorDialog('Failed to load payment page: ${error.description}');
          },
          onNavigationRequest: (NavigationRequest request) {
            _handleUrlChange(request.url);
            return NavigationDecision.navigate;
          },
        ),
      );

    // Load the PhonePe payment URL
    _controller.loadRequest(Uri.parse(widget.paymentUrl));
  }

  void _handleUrlChange(String url) {
    print('WebView URL changed: $url');
    
    // Check if the URL matches the callback URL pattern
    if (url.contains(widget.callbackUrl) || 
        url.contains('payment-status') || 
        url.contains('transaction') ||
        url.toLowerCase().contains('success') ||
        url.toLowerCase().contains('failure') ||
        url.toLowerCase().contains('cancel')) {
      
      _checkPaymentStatus();
    }
  }

  Future<void> _checkPaymentStatus() async {
    setState(() {
      _isLoading = true;
      _loadingMessage = 'Verifying payment status...';
    });

    try {
      final response = await PhonePeService.checkPaymentStatus(widget.merchantTransactionId);
      
      if (response['success']) {
        final status = response['status'];
        _handlePaymentResult(status, response);
      } else {
        _showErrorDialog('Failed to verify payment: ${response['error']}');
      }
    } catch (e) {
      _showErrorDialog('Error verifying payment: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handlePaymentResult(String status, Map<String, dynamic> response) {
    switch (status) {
      case 'COMPLETED':
        _showSuccessDialog(response);
        break;
      case 'FAILED':
        _showFailureDialog('Payment failed. Please try again.');
        break;
      case 'PENDING':
        _showPendingDialog();
        break;
      default:
        _showErrorDialog('Unknown payment status: $status');
    }
  }

  void _showSuccessDialog(Map<String, dynamic> response) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 30),
            SizedBox(width: 12),
            Text('Payment Successful'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your payment of ₹${widget.amount.toStringAsFixed(2)} has been completed successfully!'),
            const SizedBox(height: 12),
            if (response['transactionId'] != null) ...[
              Text('Transaction ID: ${response['transactionId']}',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
            ],
            Text('Merchant Transaction ID: ${widget.merchantTransactionId}',
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop({'success': true, 'data': response}); // Return to previous screen
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showFailureDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.error, color: Colors.red, size: 30),
            SizedBox(width: 12),
            Text('Payment Failed'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop({'success': false, 'error': message}); // Return to previous screen
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showPendingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.pending, color: Colors.orange, size: 30),
            SizedBox(width: 12),
            Text('Payment Pending'),
          ],
        ),
        content: const Text('Your payment is being processed. Please check back later for the status.'),
        actions: [
          TextButton(
            onPressed: () => _checkPaymentStatus(),
            child: const Text('Check Again'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop({'success': false, 'error': 'Payment pending'}); // Return to previous screen
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop({'success': false, 'error': message}); // Return to previous screen
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PhonePe Payment'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Cancel Payment'),
                content: const Text('Are you sure you want to cancel the payment?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('No'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop({'success': false, 'error': 'Payment cancelled by user'});
                    },
                    child: const Text('Yes'),
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _controller.reload();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            Container(
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _loadingMessage,
                      style: const TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
