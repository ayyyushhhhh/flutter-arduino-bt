import 'package:flutter/material.dart';

class TiltBotScreen extends StatelessWidget {
  const TiltBotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const double radius = 60;
    const double iconSize = 50;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(
                  Icons.bluetooth_disabled_outlined,
                  size: 40,
                ),
                color: Colors.black,
                onPressed: () {},
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {},
                    child: CircleAvatar(
                      radius: radius,
                      backgroundColor: Colors.purple.shade100,
                      child: const Icon(
                        Icons.keyboard_arrow_up,
                        size: iconSize,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {},
                        child: CircleAvatar(
                          radius: radius,
                          backgroundColor: Colors.purple.shade100,
                          child: const Icon(
                            Icons.keyboard_arrow_left,
                            size: iconSize,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: const CircleAvatar(
                          radius: radius * 0.8,
                          backgroundColor: Colors.red,
                          child: Icon(
                            Icons.stop_circle,
                            size: iconSize,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: CircleAvatar(
                          radius: radius,
                          backgroundColor: Colors.purple.shade100,
                          child: const Icon(
                            Icons.keyboard_arrow_right,
                            size: iconSize,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {},
                    child: CircleAvatar(
                      radius: radius,
                      backgroundColor: Colors.purple.shade100,
                      child: const Icon(
                        Icons.keyboard_arrow_down,
                        size: iconSize,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
