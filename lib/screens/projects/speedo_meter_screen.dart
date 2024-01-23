import 'package:flutter/material.dart';
import 'package:flutter_arduino/widget/speedo_meter_widget.dart';

class SpeedoMeterScreen extends StatelessWidget {
  const SpeedoMeterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
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
                color: Colors.white,
                onPressed: () {},
              ),
            ),
            const Speedometer(
              gaugeBegin: 0,
              gaugeEnd: 50,
              velocity: 20,
              velocityUnit: "m/s",
            )
          ],
        ),
      ),
    );
  }
}
