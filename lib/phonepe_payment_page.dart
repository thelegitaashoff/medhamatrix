import 'package:flutter/material.dart';
import 'services/phonepe_service.dart';
import 'phonepe_webview_page.dart';

class PhonePePaymentPage extends StatefulWidget {
  final double amount;
  final String userId;
  final String? mobileNumber;
  final String? email;
  final String callbackUrl;

  const PhonePePaymentPage({
    super.key,
    required this.amount,
    required this.userId,
    this.mobileNumber,
    this.email,
    required this.callbackUrl,
  });

  @override
  State<PhonePePaymentPage> createState() => _PhonePePaymentPageState();
}

class _PhonePePaymentPageState extends State<PhonePePaymentPage> {
  bool _isLoading = false;
  String? _paymentUrl;
  String _statusMessage = '';
  bool _paymentInitiated = false;
  String? _merchantTransactionId;

  @override
  void initState() {
    super.initState();
    _initiatePayment();
  }

  Future<void> _initiatePayment() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Initializing PhonePe payment...';
    });

    try {
      _merchantTransactionId = PhonePeService.generateTransactionId();
      
      final response = await PhonePeService.initiatePayment(
        merchantTransactionId: _merchantTransactionId!,
        amount: widget.amount,
        userId: widget.userId,
        callbackUrl: widget.callbackUrl,
        mobileNumber: widget.mobileNumber,
        email: widget.email,
      );

      if (response['success']) {
        setState(() {
          _paymentUrl = response['redirectUrl'];
          _paymentInitiated = true;
          _statusMessage = 'Payment initiated successfully!';
        });
        
        // Open PhonePe payment in WebView
        if (_paymentUrl != null) {
          _openPaymentWebView();
        }
      } else {
        setState(() {
          _statusMessage = 'Payment initiation failed: ${response['error']}';
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _checkPaymentStatus() async {
    if (_paymentInitiated) {
      setState(() {
        _isLoading = true;
        _statusMessage = 'Checking payment status...';
      });

      try {
        if (_merchantTransactionId == null) {
          setState(() {
            _statusMessage = 'No transaction ID found. Please initiate payment first.';
          });
          return;
        }
        final response = await PhonePeService.checkPaymentStatus(_merchantTransactionId!);

        if (response['success']) {
          final status = response['status'];
          setState(() {
            _statusMessage = 'Payment status: $status';
          });
          
          if (status == 'COMPLETED') {
            _showSuccessDialog();
          } else if (status == 'FAILED') {
            _showFailureDialog();
          }
        } else {
          setState(() {
            _statusMessage = 'Failed to check status: ${response['error']}';
          });
        }
      } catch (e) {
        setState(() {
          _statusMessage = 'Error checking status: $e';
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _openPaymentWebView() async {
    if (_paymentUrl == null || _merchantTransactionId == null) {
      setState(() {
        _statusMessage = 'Payment URL or transaction ID is missing.';
      });
      return;
    }

    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => PhonePeWebViewPage(
          paymentUrl: _paymentUrl!,
          merchantTransactionId: _merchantTransactionId!,
          callbackUrl: widget.callbackUrl,
          amount: widget.amount,
        ),
      ),
    );

    if (result != null) {
      if (result['success'] == true) {
        _showSuccessDialog();
      } else {
        setState(() {
          _statusMessage = 'Payment failed: ${result['error']}';
          _paymentInitiated = false;
        });
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Payment Successful'),
        content: const Text('Your payment has been completed successfully!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showFailureDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Payment Failed'),
        content: const Text('Your payment could not be processed. Please try again.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
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
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Payment Summary
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Payment Summary',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Amount:',
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                        Text(
                          '₹${widget.amount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'User ID:',
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                        Text(
                          widget.userId,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Status Display
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _paymentInitiated ? Colors.green : Colors.orange,
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    if (_isLoading)
                      const CircularProgressIndicator()
                    else
                      Icon(
                        _paymentInitiated ? Icons.check_circle : Icons.info,
                        color: _paymentInitiated ? Colors.green : Colors.orange,
                        size: 48,
                      ),
                    const SizedBox(height: 12),
                    Text(
                      _statusMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: _paymentInitiated ? Colors.green : Colors.orange,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Payment URL Display
              if (_paymentUrl != null) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Payment URL:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SelectableText(
                        _paymentUrl!,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
              
              // Action Buttons
              if (_paymentInitiated) ...[
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : () {
                    if (_paymentUrl != null) {
                      _openPaymentWebView();
                    }
                  },
                  icon: const Icon(Icons.payment),
                  label: const Text('Open PhonePe Payment'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _checkPaymentStatus,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Check Payment Status'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Cancel Payment'),
                ),
              ],
              
              const Spacer(),
              
              // Instructions
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Instructions:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '• You will be redirected to PhonePe for secure payment',
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    Text(
                      '• Complete the payment on PhonePe app or website',
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    Text(
                      '• Return to this app after payment completion',
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
