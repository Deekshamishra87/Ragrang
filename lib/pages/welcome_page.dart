import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:lottie/lottie.dart';
import 'package:rag_rang_app/widgets/navbar_widget.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool _hasNavigated = false;

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!_hasNavigated && mounted) {
      setState(() => _hasNavigated = true);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const NavbarWidget()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade200, Colors.deepPurple.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: LiquidPullToRefresh(
          onRefresh: _handleRefresh,
          color: Colors.deepPurple,
          backgroundColor: Colors.deepPurple.shade200,
          height: 300,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 25),
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Lottie.asset(
                    'assets/lotties/another.json',
                    fit: BoxFit.contain,
                    repeat: true,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const Center(
                child: Text(
                  "⬇ Pull down to enter RagRang ⬇",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
