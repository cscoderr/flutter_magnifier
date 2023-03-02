import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_manifier_effect/app_constants.dart';

class HomeControls extends StatelessWidget {
  const HomeControls({
    super.key,
    required this.size,
    required this.scale,
    required this.rotation,
  });

  final ValueNotifier<double> size;
  final ValueNotifier<double> scale;
  final ValueNotifier<double> rotation;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Customization',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Text('Scale'),
                    Expanded(
                      child: ValueListenableBuilder(
                          valueListenable: scale,
                          builder: (context, value, child) {
                            return Slider(
                              value: value,
                              min: AppConstants.minScale,
                              max: AppConstants.maxScale,
                              onChanged: (value) {
                                scale.value = value;
                              },
                            );
                          }),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    const Text('Rotation'),
                    Expanded(
                      child: ValueListenableBuilder(
                          valueListenable: rotation,
                          builder: (context, value, child) {
                            return Slider(
                              value: value,
                              min: 0 * math.pi / 180,
                              max: 360 * math.pi / 180,
                              onChanged: (value) {
                                rotation.value = value;
                              },
                            );
                          }),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Text('Size'),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: size,
                  builder: (context, value, child) {
                    return Slider(
                      value: value,
                      min: AppConstants.minSize,
                      max: AppConstants.maxSize,
                      onChanged: (value) {
                        size.value = value;
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
