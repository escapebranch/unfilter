package com.escapebranch.unfilter

import android.content.Context
import android.content.pm.PackageManager
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.hardware.TriggerEvent
import android.hardware.TriggerEventListener
import android.os.Build
import android.util.Log
import androidx.core.content.ContextCompat
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class SensorDiagnosticsManager(private val context: Context) : MethodChannel.MethodCallHandler, EventChannel.StreamHandler {
    private val sensorManager = context.getSystemService(Context.SENSOR_SERVICE) as SensorManager
    private var activeListener: SensorEventListener? = null
    private var activeTriggerListener: TriggerEventListener? = null
    private var activeSensor: Sensor? = null
    private var activeSink: EventChannel.EventSink? = null

    companion object {
        private const val TAG = "SensorDiagManager"
    }

    fun register(messenger: BinaryMessenger) {
        MethodChannel(messenger, "com.escapebranch.unfilter/sensors").setMethodCallHandler(this)
        EventChannel(messenger, "com.escapebranch.unfilter/sensor_stream").setStreamHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getSensorsList" -> {
                try {
                    val sensors = sensorManager.getSensorList(Sensor.TYPE_ALL)
                    val response = sensors.map { sensor ->
                        val reportingModeStr = when (sensor.reportingMode) {
                            Sensor.REPORTING_MODE_CONTINUOUS -> "continuous"
                            Sensor.REPORTING_MODE_ON_CHANGE -> "on_change"
                            Sensor.REPORTING_MODE_ONE_SHOT -> "one_shot"
                            Sensor.REPORTING_MODE_SPECIAL_TRIGGER -> "special_trigger"
                            else -> "unknown"
                        }

                        val isWakeUp = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                            sensor.isWakeUpSensor
                        } else {
                            false
                        }

                        mapOf(
                            "name" to sensor.name,
                            "type" to sensor.type,
                            "stringType" to (sensor.stringType ?: ""),
                            "vendor" to sensor.vendor,
                            "version" to sensor.version,
                            "power" to sensor.power,
                            "resolution" to sensor.resolution,
                            "maximumRange" to sensor.maximumRange,
                            "reportingMode" to reportingModeStr,
                            "isWakeUp" to isWakeUp,
                            "fifoMaxEventCount" to sensor.fifoMaxEventCount,
                            "minDelay" to sensor.minDelay
                        )
                    }
                    result.success(response)
                } catch (e: Exception) {
                    Log.e(TAG, "Error getting sensors list: ${e.message}", e)
                    result.error("ERROR", "Failed to retrieve sensors: ${e.message}", null)
                }
            }
            else -> result.notImplemented()
        }
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        if (events == null) return
        activeSink = events

        try {
            val sensorType = when (arguments) {
                is Int -> arguments
                is Number -> arguments.toInt()
                else -> {
                    events.error("INVALID_ARGUMENT", "Sensor type must be an integer", null)
                    return
                }
            }

            // Fallback: Check default sensor first, then first matching sensor in system list
            val sensor = sensorManager.getDefaultSensor(sensorType)
                ?: sensorManager.getSensorList(sensorType).firstOrNull()

            if (sensor == null) {
                events.error("SENSOR_NOT_AVAILABLE", "Sensor of type $sensorType is not available on this device", null)
                return
            }

            // Check runtime permissions if applicable
            val permissionError = checkSensorPermissions(sensorType)
            if (permissionError != null) {
                events.error("PERMISSION_DENIED", permissionError, null)
                return
            }

            cancelActiveListener()
            activeSensor = sensor

            // Handle ONE_SHOT reporting mode sensors using TriggerEventListener
            if (sensor.reportingMode == Sensor.REPORTING_MODE_ONE_SHOT) {
                val triggerListener = object : TriggerEventListener() {
                    override fun onTrigger(event: TriggerEvent?) {
                        if (event != null) {
                            val valuesMap = mapOf(
                                "values" to event.values.map { if (it.isNaN() || it.isInfinite()) 0.0 else it.toDouble() },
                                "timestamp" to event.timestamp,
                                "accuracy" to 3,
                                "isTrigger" to true
                            )
                            activeSink?.success(valuesMap)
                        }
                    }
                }
                activeTriggerListener = triggerListener
                val success = sensorManager.requestTriggerSensor(triggerListener, sensor)
                if (!success) {
                    events.error("REGISTRATION_FAILED", "Failed to request trigger sensor for type $sensorType", null)
                }
                return
            }

            // Standard continuous / on_change listener
            val listener = object : SensorEventListener {
                override fun onSensorChanged(event: SensorEvent?) {
                    if (event != null && event.sensor.type == sensorType) {
                        try {
                            val rawValues = event.values ?: return
                            val size = rawValues.size
                            val sanitizedValues = ArrayList<Double>(size)
                            for (i in 0 until size) {
                                val v = rawValues[i].toDouble()
                                sanitizedValues.add(if (v.isNaN() || v.isInfinite()) 0.0 else v)
                            }
                            val valuesMap = mapOf(
                                "values" to sanitizedValues,
                                "timestamp" to event.timestamp,
                                "accuracy" to event.accuracy,
                                "reportingMode" to sensor.reportingMode
                            )
                            activeSink?.success(valuesMap)
                        } catch (e: Exception) {
                            Log.e(TAG, "Error processing sensor event: ${e.message}", e)
                        }
                    }
                }

                override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {}
            }

            activeListener = listener

            // Try registration with SENSOR_DELAY_UI, falling back to GAME, NORMAL, FASTEST
            val registered = sensorManager.registerListener(listener, sensor, SensorManager.SENSOR_DELAY_UI) ||
                    sensorManager.registerListener(listener, sensor, SensorManager.SENSOR_DELAY_GAME) ||
                    sensorManager.registerListener(listener, sensor, SensorManager.SENSOR_DELAY_NORMAL) ||
                    sensorManager.registerListener(listener, sensor, SensorManager.SENSOR_DELAY_FASTEST)

            if (!registered) {
                events.error("REGISTRATION_FAILED", "Hardware failed to register listener for sensor: ${sensor.name}", null)
            }
        } catch (e: SecurityException) {
            Log.e(TAG, "Security exception starting sensor listener: ${e.message}", e)
            events.error("PERMISSION_DENIED", "Security permission denied for sensor: ${e.message}", null)
        } catch (e: Exception) {
            Log.e(TAG, "Error starting sensor listener: ${e.message}", e)
            events.error("ERROR", "Failed to start sensor: ${e.message}", null)
        }
    }

    private fun checkSensorPermissions(sensorType: Int): String? {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            if (sensorType == Sensor.TYPE_STEP_COUNTER || sensorType == Sensor.TYPE_STEP_DETECTOR) {
                if (ContextCompat.checkSelfPermission(context, android.Manifest.permission.ACTIVITY_RECOGNITION) != PackageManager.PERMISSION_GRANTED) {
                    return "Activity Recognition permission is required to access Step Sensors."
                }
            }
        }
        if (sensorType == Sensor.TYPE_HEART_RATE || sensorType == Sensor.TYPE_HEART_BEAT) {
            if (ContextCompat.checkSelfPermission(context, android.Manifest.permission.BODY_SENSORS) != PackageManager.PERMISSION_GRANTED) {
                return "Body Sensors permission is required to access Heart Rate sensors."
            }
        }
        return null
    }

    override fun onCancel(arguments: Any?) {
        cancelActiveListener()
        activeSink = null
    }

    private fun cancelActiveListener() {
        try {
            activeListener?.let {
                sensorManager.unregisterListener(it)
                activeListener = null
            }
            activeTriggerListener?.let {
                activeSensor?.let { sensor ->
                    sensorManager.cancelTriggerSensor(it, sensor)
                }
                activeTriggerListener = null
            }
            activeSensor = null
        } catch (e: Exception) {
            Log.e(TAG, "Error unregistering sensor listener: ${e.message}", e)
        }
    }
}

