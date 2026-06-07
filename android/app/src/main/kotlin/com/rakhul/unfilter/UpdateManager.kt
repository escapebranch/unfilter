package com.escapebranch.unfilter

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.util.Log
import com.google.android.play.core.appupdate.AppUpdateInfo
import com.google.android.play.core.appupdate.AppUpdateManager
import com.google.android.play.core.appupdate.AppUpdateManagerFactory
import com.google.android.play.core.install.InstallState
import com.google.android.play.core.install.InstallStateUpdatedListener
import com.google.android.play.core.install.model.AppUpdateType
import com.google.android.play.core.install.model.InstallStatus
import com.google.android.play.core.install.model.UpdateAvailability
import io.flutter.plugin.common.MethodChannel

class UpdateManager(private val context: Context) {
    private val appUpdateManager: AppUpdateManager = AppUpdateManagerFactory.create(context)
    private var installStateUpdatedListener: InstallStateUpdatedListener? = null
    private var statusSink: ((Map<String, Any?>) -> Unit)? = null

    companion object {
        private const val TAG = "UpdateManager"
        const val UPDATE_REQUEST_CODE = 1234
    }

    fun setStatusListener(listener: (Map<String, Any?>) -> Unit) {
        this.statusSink = listener
    }

    fun checkForUpdate(result: MethodChannel.Result) {
        val appUpdateInfoTask = appUpdateManager.appUpdateInfo
        appUpdateInfoTask.addOnSuccessListener { appUpdateInfo ->
            val availability = mapAvailability(appUpdateInfo.updateAvailability())

            val response = mapOf(
                "availability" to availability,
                "availableVersionCode" to appUpdateInfo.availableVersionCode(),
                "updatePriority" to appUpdateInfo.updatePriority(),
                "isFlexibleUpdateAllowed" to appUpdateInfo.isUpdateTypeAllowed(AppUpdateType.FLEXIBLE),
                "isImmediateUpdateAllowed" to appUpdateInfo.isUpdateTypeAllowed(AppUpdateType.IMMEDIATE),
                "bytesDownloaded" to appUpdateInfo.bytesDownloaded(),
                "totalBytesToDownload" to appUpdateInfo.totalBytesToDownload(),
                "clientVersionStalenessDays" to appUpdateInfo.clientVersionStalenessDays(),
                "installStatus" to mapInstallStatus(appUpdateInfo.installStatus())
            )
            result.success(response)
        }.addOnFailureListener { e ->
            result.error("UPDATE_CHECK_FAILED", e.message, null)
        }
    }

    fun handleOnResume(activity: Activity) {
        appUpdateManager.appUpdateInfo.addOnSuccessListener { appUpdateInfo ->
            // For flexible updates: check if it's already downloaded
            if (appUpdateInfo.installStatus() == InstallStatus.DOWNLOADED) {
                notifyStatus(appUpdateInfo.installStatus(), appUpdateInfo.bytesDownloaded(), appUpdateInfo.totalBytesToDownload(), 0)
            }

            // For immediate updates: resume if in progress
            if (appUpdateInfo.updateAvailability() == UpdateAvailability.DEVELOPER_TRIGGERED_UPDATE_IN_PROGRESS) {
                try {
                    appUpdateManager.startUpdateFlowForResult(
                        appUpdateInfo,
                        AppUpdateType.IMMEDIATE,
                        activity,
                        UPDATE_REQUEST_CODE
                    )
                } catch (e: Exception) {
                    Log.e(TAG, "Failed to resume immediate update", e)
                }
            }
        }
    }

    fun startUpdate(activity: Activity, type: String, result: MethodChannel.Result) {
        val appUpdateType = if (type == "IMMEDIATE") AppUpdateType.IMMEDIATE else AppUpdateType.FLEXIBLE
        
        appUpdateManager.appUpdateInfo.addOnSuccessListener { appUpdateInfo ->
            if (appUpdateInfo.isUpdateTypeAllowed(appUpdateType)) {
                if (appUpdateType == AppUpdateType.FLEXIBLE) {
                    registerInstallStateListener()
                }
                
                try {
                    appUpdateManager.startUpdateFlowForResult(
                        appUpdateInfo,
                        appUpdateType,
                        activity,
                        UPDATE_REQUEST_CODE
                    )
                    result.success(true)
                } catch (e: Exception) {
                    result.error("UPDATE_FLOW_FAILED", e.message, null)
                }
            } else {
                result.error("UPDATE_TYPE_NOT_ALLOWED", "Update type $type is not allowed", null)
            }
        }.addOnFailureListener { e ->
            result.error("UPDATE_INFO_FAILED", e.message, null)
        }
    }

    fun completeUpdate(result: MethodChannel.Result) {
        appUpdateManager.completeUpdate().addOnSuccessListener {
            result.success(true)
        }.addOnFailureListener { e ->
            result.error("COMPLETE_UPDATE_FAILED", e.message, null)
        }
    }

    private fun registerInstallStateListener() {
        if (installStateUpdatedListener != null) return

        installStateUpdatedListener = InstallStateUpdatedListener { state ->
            notifyStatus(state.installStatus(), state.bytesDownloaded(), state.totalBytesToDownload(), state.installErrorCode())
        }
        appUpdateManager.registerListener(installStateUpdatedListener!!)
    }

    private fun notifyStatus(installStatus: Int, bytesDownloaded: Long, totalBytesToDownload: Long, errorCode: Int) {
        val status = mapInstallStatus(installStatus)

        val event = mapOf(
            "status" to status,
            "bytesDownloaded" to bytesDownloaded,
            "totalBytesToDownload" to totalBytesToDownload,
            "installErrorCode" to errorCode
        )
        statusSink?.invoke(event)
    }

    private fun mapAvailability(availability: Int): String {
        return when (availability) {
            UpdateAvailability.UPDATE_AVAILABLE -> "AVAILABLE"
            UpdateAvailability.DEVELOPER_TRIGGERED_UPDATE_IN_PROGRESS -> "IN_PROGRESS"
            UpdateAvailability.UPDATE_NOT_AVAILABLE -> "NOT_AVAILABLE"
            UpdateAvailability.UNKNOWN -> "UNKNOWN"
            else -> "UNKNOWN"
        }
    }

    private fun mapInstallStatus(status: Int): String {
        return when (status) {
            InstallStatus.CANCELED -> "CANCELED"
            InstallStatus.DOWNLOADED -> "DOWNLOADED"
            InstallStatus.DOWNLOADING -> "DOWNLOADING"
            InstallStatus.FAILED -> "FAILED"
            InstallStatus.INSTALLED -> "INSTALLED"
            InstallStatus.INSTALLING -> "INSTALLING"
            InstallStatus.PENDING -> "PENDING"
            InstallStatus.UNKNOWN -> "UNKNOWN"
            else -> "UNKNOWN"
        }
    }

    fun unregisterListener() {
        installStateUpdatedListener?.let {
            appUpdateManager.unregisterListener(it)
            installStateUpdatedListener = null
        }
    }
}

