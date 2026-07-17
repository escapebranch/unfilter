import 'package:flutter/material.dart';

enum SensorCategory {
  motion3D,
  pedometer,
  environment1D,
  proximity,
  orientation,
  generic,
}

SensorCategory getSensorCategory(int type) {
  switch (type) {
    case 1: // TYPE_ACCELEROMETER
    case 2: // TYPE_MAGNETIC_FIELD
    case 4: // TYPE_GYROSCOPE
    case 9: // TYPE_GRAVITY
    case 10: // TYPE_LINEAR_ACCELERATION
    case 11: // TYPE_ROTATION_VECTOR
      return SensorCategory.motion3D;

    case 18: // TYPE_STEP_DETECTOR
    case 19: // TYPE_STEP_COUNTER
      return SensorCategory.pedometer;

    case 5: // TYPE_LIGHT
    case 6: // TYPE_PRESSURE
    case 12: // TYPE_RELATIVE_HUMIDITY
    case 13: // TYPE_AMBIENT_TEMPERATURE
      return SensorCategory.environment1D;

    case 8: // TYPE_PROXIMITY
      return SensorCategory.proximity;

    case 3: // TYPE_ORIENTATION
    case 36: // TYPE_HINGE_ANGLE
      return SensorCategory.orientation;

    default:
      return SensorCategory.generic;
  }
}

String getSensorUnit(int type) {
  switch (type) {
    case 1: case 9: case 10: return 'm/s²';
    case 2: return 'μT';
    case 4: return 'rad/s';
    case 5: return 'lx';
    case 6: return 'hPa';
    case 8: return 'cm';
    case 12: return '%';
    case 13: return '°C';
    case 18: case 19: return 'steps';
    case 3: case 36: return '°';
    default: return '';
  }
}

IconData getSensorIcon(int type) {
  switch (type) {
    case 1: return Icons.directions_run_rounded;
    case 2: return Icons.explore_rounded;
    case 4: return Icons.screen_rotation_rounded;
    case 5: return Icons.wb_sunny_rounded;
    case 6: return Icons.compress_rounded;
    case 8: return Icons.hearing_rounded;
    case 12: return Icons.opacity_rounded;
    case 13: return Icons.thermostat_rounded;
    case 18: case 19: return Icons.directions_walk_rounded;
    case 3: case 36: return Icons.compass_calibration_rounded;
    default: return Icons.sensors_rounded;
  }
}

String getSensorDescription(int type) {
  switch (type) {
    case 1: return 'Measures acceleration force along the x, y, and z axes.';
    case 2: return 'Measures the ambient magnetic field for all three physical axes.';
    case 4: return 'Measures the device\'s rate of rotation around the x, y, and z axes.';
    case 5: return 'Measures the ambient light level (illumination).';
    case 6: return 'Measures the ambient air pressure.';
    case 8: return 'Measures the distance of an object relative to the view screen.';
    case 9: return 'Measures the force of gravity applied to the device on all three axes.';
    case 10: return 'Measures the acceleration force without gravity.';
    case 11: return 'Measures the rotation vector component of the device.';
    case 12: return 'Measures the relative ambient humidity.';
    case 13: return 'Measures the ambient room temperature.';
    case 18: return 'Detects step triggers. Fires an event on each physical step taken.';
    case 19: return 'Measures cumulative steps taken since the last device reboot.';
    case 3: return 'Measures degrees of rotation around all three physical axes.';
    case 36: return 'Measures the angle between two physical device panels.';
    default: return 'Hardware sensor component.';
  }
}
