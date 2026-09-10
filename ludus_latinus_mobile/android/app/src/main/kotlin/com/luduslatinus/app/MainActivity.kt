package com.luduslatinus.app

import android.content.res.AssetFileDescriptor
import android.media.AudioAttributes
import android.media.SoundPool
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.luduslatinus/audio"
    private var soundPool: SoundPool? = null
    private val soundMap = HashMap<String, Int>()
    private val loadedSounds = HashSet<Int>()
    private val pendingPlays = HashMap<Int, Float>()

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        try {
            val attributes = AudioAttributes.Builder()
                .setUsage(AudioAttributes.USAGE_GAME)
                .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                .build()

            val pool = SoundPool.Builder()
                .setMaxStreams(10)
                .setAudioAttributes(attributes)
                .build()

            pool.setOnLoadCompleteListener { sp, sampleId, status ->
                if (status == 0) {
                    loadedSounds.add(sampleId)
                    val pendingVol = pendingPlays.remove(sampleId)
                    if (pendingVol != null) {
                        sp.play(sampleId, pendingVol, pendingVol, 1, 0, 1.0f)
                    }
                }
            }
            soundPool = pool
        } catch (e: Exception) {
            Log.e("LudusAudio", "SoundPool initialization failed", e)
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "play" -> {
                    val asset = call.argument<String>("asset")
                    val volume = (call.argument<Double>("volume") ?: 1.0).toFloat()
                    if (asset != null) {
                        playSound(asset, volume)
                        result.success(true)
                    } else {
                        result.error("INVALID_ASSET", "Asset cannot be null", null)
                    }
                }
                "stopAll" -> {
                    soundPool?.autoPause()
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun playSound(assetPath: String, volume: Float) {
        val pool = soundPool ?: return
        try {
            var soundId = soundMap[assetPath]
            if (soundId == null) {
                val flutterAssetKey = "flutter_assets/$assetPath"
                val afd: AssetFileDescriptor = context.assets.openFd(flutterAssetKey)
                soundId = pool.load(afd, 1)
                afd.close()
                soundMap[assetPath] = soundId
                pendingPlays[soundId] = volume
            } else {
                if (loadedSounds.contains(soundId)) {
                    pool.play(soundId, volume, volume, 1, 0, 1.0f)
                } else {
                    pendingPlays[soundId] = volume
                }
            }
        } catch (e: Exception) {
            Log.e("LudusAudio", "Failed to play $assetPath", e)
        }
    }

    override fun onDestroy() {
        soundPool?.release()
        soundPool = null
        super.onDestroy()
    }
}