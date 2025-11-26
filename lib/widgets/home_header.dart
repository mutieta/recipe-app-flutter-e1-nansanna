import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _iconBox(Icons.equalizer),
          const Text("Welcome Shafiqul",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          Stack(
            children: [
              _iconBox(Icons.notifications_none),
              Positioned(
                right: 4,
                top: 4,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: const BoxDecoration(
                    color: Color(0xfff9c600),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text("5",
                        style: TextStyle(fontSize: 10, color: Colors.black)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _iconBox(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: Colors.white),
    );
  }
}
