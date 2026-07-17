package com.escapebranch.unfilter

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.util.Log
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class SensorDiagnosticsManager(private val context: Context) : MethodChannel.MethodCallHandler, EventChannel.StreamHandler {
    private val sensorManager = context.getSystemService(Context.SENSOR_SERVICE) as SensorManager
    private var activeListener: SensorEventListener? = null
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
                        mapOf(
                            "name" to sensor.name,
                            "type" to sensor.type,
                            "stringType" to sensor.stringType,
                            "vendor" to sensor.vendor,
                            "version" to sensor.version,
                            "power" to sensor.power,
                            "resolution" to sensor.resolution,
                            "maximumRange" to sensor.maximumRange
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

            val sensor = sensorManager.getDefaultSensor(sensorType)
            if (sensor == null) {
                events.error("SENSOR_NOT_AVAILABLE", "Sensor of type $sensorType is not available on this device", null)
                return
            }

            cancelActiveListener()

            activeSensor = sensor
            activeListener = object : SensorEventListener {
                override fun onSensorChanged(event: SensorEvent?) {
                    if (event != null && event.sensor.type == sensorType) {
                        val valuesMap = mapOf(
                            "values" to event.values.toList(),
                            "timestamp" to event.timestamp,
                            "accuracy" to event.accuracy
                        )
                        activeSink?.success(valuesMap)
                    }
                }

                override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {}
            }

            sensorManager.registerListener(activeListener, sensor, SensorManager.SENSOR_DELAY_UI)
        } catch (e: Exception) {
            Log.e(TAG, "Error starting sensor listener: ${e.message}", e)
            events.error("ERROR", "Failed to start sensor: ${e.message}", null)
        }
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
            activeSensor = null
        } catch (e: Exception) {
            Log.e(TAG, "Error unregistering sensor listener: ${e.message}", e)
        }
    }
}
