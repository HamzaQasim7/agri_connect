import 'package:agriconnect/app_theme.dart';
import 'package:agriconnect/data/IoT/models/telemetry_data.dart';
import 'package:agriconnect/ui/IoT/reload_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class TelemetryDataReading extends StatelessWidget {
  const TelemetryDataReading({required this.data, required this.reloadTime});

  final String data;
  final ReloadTime reloadTime;

  @override
  Widget build(BuildContext context) {
    TelemetryData telemetryData = context.watch<TelemetryData>();

    if (telemetryData == null) {
      return _buildReading("N/A");
    } else {
      if (reloadTime != null && telemetryData.timestamp != null) {
        Future.delayed(
          Duration.zero,
          () => reloadTime.update(telemetryData.timestamp),
        );
      }
      return _buildReading(telemetryData.value ?? "N/A");
    }
  }

  Text _buildReading(String reading) {
    return Text(
      reading,
      textAlign: TextAlign.right,
      style: TextStyle(
        fontFamily: AppTheme.fontName,
        fontWeight: FontWeight.w500,
        fontSize: 50,
        letterSpacing: 0.0,
        color: AppTheme.white,
      ),
    );
  }
}
