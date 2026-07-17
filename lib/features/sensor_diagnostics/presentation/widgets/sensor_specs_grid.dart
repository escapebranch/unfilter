import 'package:flutter/material.dart';

class SensorSpecsGrid extends StatelessWidget {
  final double power;
  final double resolution;
  final double maxRange;
  final int typeId;
  final String reportingMode;
  final bool isWakeUp;
  final int minDelay;
  final int fifoMaxEventCount;

  const SensorSpecsGrid({
    super.key,
    required this.power,
    required this.resolution,
    required this.maxRange,
    required this.typeId,
    this.reportingMode = 'continuous',
    this.isWakeUp = false,
    this.minDelay = 0,
    this.fifoMaxEventCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final labelStyle = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
      fontWeight: FontWeight.w700,
      fontSize: 10,
      letterSpacing: 0.8,
    );
    final valueStyle = theme.textTheme.bodySmall?.copyWith(
      fontFamily: 'monospace',
      fontWeight: FontWeight.w500,
    );

    final formattedMode = reportingMode.replaceAll('_', ' ').toUpperCase();

    return Table(
      children: [
        TableRow(
          children: [
            _buildSpecCell('POWER', '${power.toStringAsFixed(3)} mA', labelStyle, valueStyle),
            _buildSpecCell('RESOLUTION', resolution.toStringAsPrecision(4), labelStyle, valueStyle),
          ],
        ),
        const TableRow(
          children: [
            SizedBox(height: 12),
            SizedBox(height: 12),
          ],
        ),
        TableRow(
          children: [
            _buildSpecCell('MAX RANGE', maxRange.toStringAsPrecision(4), labelStyle, valueStyle),
            _buildSpecCell('TYPE ID', typeId.toString(), labelStyle, valueStyle),
          ],
        ),
        const TableRow(
          children: [
            SizedBox(height: 12),
            SizedBox(height: 12),
          ],
        ),
        TableRow(
          children: [
            _buildSpecCell('REPORTING MODE', formattedMode, labelStyle, valueStyle),
            _buildSpecCell('WAKE-UP SENSOR', isWakeUp ? 'YES' : 'NO', labelStyle, valueStyle),
          ],
        ),
        const TableRow(
          children: [
            SizedBox(height: 12),
            SizedBox(height: 12),
          ],
        ),
        TableRow(
          children: [
            _buildSpecCell('MIN DELAY', minDelay > 0 ? '$minDelay µs' : 'Dynamic / 0 µs', labelStyle, valueStyle),
            _buildSpecCell('FIFO BUFFER', fifoMaxEventCount > 0 ? '$fifoMaxEventCount events' : 'None', labelStyle, valueStyle),
          ],
        ),
      ],
    );
  }

  Widget _buildSpecCell(String label, String value, TextStyle? labelStyle, TextStyle? valueStyle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: labelStyle),
        const SizedBox(height: 4),
        Text(value, style: valueStyle, maxLines: 1, overflow: TextOverflow.ellipsis),
      ],
    );
  }
}

