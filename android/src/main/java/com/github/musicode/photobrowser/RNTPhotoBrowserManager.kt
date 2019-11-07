package com.github.musicode.photobrowser

import android.content.Context
import android.graphics.Bitmap
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.Drawable
import android.media.MediaScannerConnection
import android.net.Uri
import android.os.Environment
import android.util.Log
import android.view.View
import android.webkit.URLUtil
import android.widget.ImageView

import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReadableArray
import com.facebook.react.bridge.WritableMap
import com.facebook.react.common.MapBuilder
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.annotations.ReactProp
import com.facebook.react.uimanager.events.RCTEventEmitter
import com.github.herokotlin.photobrowser.PhotoBrowser
import com.github.herokotlin.photobrowser.PhotoBrowserCallback
import com.github.herokotlin.photobrowser.PhotoBrowserConfiguration
import com.github.herokotlin.photobrowser.model.Photo

import java.io.File
import java.io.FileNotFoundException
import java.io.FileOutputStream
import java.nio.ByteBuffer
import java.util.ArrayList
import java.util.HashMap

class RNTPhotoBrowserManager(private val reactContext: ReactApplicationContext) : SimpleViewManager<RNTPhotoBrowser>() {

    override fun getName(): String {
        return "RNTPhotoBrowser"
    }

    override fun createViewInstance(reactContext: ThemedReactContext): RNTPhotoBrowser {
        val view = RNTPhotoBrowser(reactContext)
        view.configuration = configuration
        view.callback = object : PhotoBrowserCallback {
            override fun onChange(photo: Photo, index: Int) {

            }

            override fun onTap(photo: Photo, index: Int) {

                val map = Arguments.createMap()
                map.putString("thumbnailUrl", photo.thumbnailUrl)
                map.putString("highQualityUrl", photo.highQualityUrl)
                map.putString("rawUrl", photo.rawUrl)
                map.putString("currentUrl", photo.currentUrl)

                val event = Arguments.createMap()
                event.putInt("index", index)
                event.putMap("photo", map)

                sendMessage(view, "onTap", event)

            }

            override fun onLongPress(photo: Photo, index: Int) {

                imageLoader.getImageCachePath(
                        photo.currentUrl
                ) { path ->
                    val map = Arguments.createMap()
                    map.putString("thumbnailUrl", photo.thumbnailUrl)
                    map.putString("highQualityUrl", photo.highQualityUrl)
                    map.putString("rawUrl", photo.rawUrl)
                    map.putString("currentUrl", photo.currentUrl)
                    map.putString("currentPath", path)

                    val event = Arguments.createMap()
                    event.putInt("index", index)
                    event.putMap("photo", map)

                    sendMessage(view, "onLongPress", event)

                }

            }

            override fun onSave(photo: Photo, index: Int, success: Boolean) {

                val map = Arguments.createMap()
                map.putString("thumbnailUrl", photo.thumbnailUrl)
                map.putString("highQualityUrl", photo.highQualityUrl)
                map.putString("rawUrl", photo.rawUrl)
                map.putString("currentUrl", photo.currentUrl)

                val event = Arguments.createMap()
                event.putInt("index", index)
                event.putMap("photo", map)
                event.putBoolean("success", success)

                sendMessage(view, "onSaveComplete", event)

            }
        }
        return view
    }

    @ReactProp(name = "indicator")
    fun setIndicator(view: RNTPhotoBrowser, indicator: Int) {
        if (indicator == 1) {
            view.indicator = PhotoBrowser.IndicatorType.DOT
        } else if (indicator == 2) {
            view.indicator = PhotoBrowser.IndicatorType.NUMBER
        } else {
            view.indicator = PhotoBrowser.IndicatorType.NONE
        }
    }

    @ReactProp(name = "pageMargin")
    fun setPageMargin(view: RNTPhotoBrowser, pageMargin: Int) {
        view.pageMargin = pageMargin
    }

    @ReactProp(name = "index")
    fun setIndex(view: RNTPhotoBrowser, index: Int) {
        view.index = index
    }

    @ReactProp(name = "list")
    fun setList(view: RNTPhotoBrowser, list: ReadableArray) {

        val photos = ArrayList<Photo>()

        for (i in 0 until list.size()) {
            val item = list.getMap(i)

            val thumbnailUrl = item!!.getString("thumbnailUrl")
            val highQualityUrl = item.getString("highQualityUrl")
            val rawUrl = item.getString("rawUrl")

            val photo = Photo(thumbnailUrl!!, highQualityUrl!!, rawUrl!!, "", false, false, false, false, false, 1f)
            photos.add(photo)
        }

        view.photos = photos

    }

    override fun getExportedCustomBubblingEventTypeConstants(): MutableMap<String, Any> {
        return MapBuilder.builder<String, Any>()
                .put("onTap", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onTap")))
                .put("onLongPress", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onLongPress")))
                .put("onSaveComplete", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onSaveComplete")))
                .put("onDetectComplete", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onDetectComplete")))
                .build()
    }

    override fun getCommandsMap(): MutableMap<String, Int> {
        val commands = HashMap<String, Int>()
        commands["save"] = COMMAND_SAVE
        commands["detect"] = COMMAND_DETECT
        return commands
    }

    override fun receiveCommand(root: RNTPhotoBrowser, commandId: Int, args: ReadableArray?) {
        when (commandId) {
            COMMAND_SAVE -> root.saveImage()
            COMMAND_DETECT -> root.detectQRCode { s ->
                val event = Arguments.createMap()
                event.putString("text", s)
                sendMessage(root, "onDetectComplete", event)
            }
        }
    }

    override fun onDropViewInstance(view: RNTPhotoBrowser) {
        super.onDropViewInstance(view)
        view.destroy()
    }

    private fun sendMessage(view: View, name: String, event: WritableMap) {
        reactContext.getJSModule(RCTEventEmitter::class.java).receiveEvent(view.id, name, event)
    }

    companion object {

        private const val COMMAND_SAVE = 1

        private const val COMMAND_DETECT = 2

        private var isScannerConnected: Boolean? = false

        private lateinit var configuration: PhotoBrowserConfiguration

        var albumName = ""

        lateinit var imageLoader: RNTPhotoBrowserLoader

        fun setImageLoader(context: Context, loader: RNTPhotoBrowserLoader) {

            val scanner = MediaScannerConnection(context, object : MediaScannerConnection.MediaScannerConnectionClient {
                override fun onMediaScannerConnected() {
                    isScannerConnected = true
                }

                override fun onScanCompleted(path: String, uri: Uri) {

                }
            })

            scanner.connect()

            imageLoader = loader

            configuration = object : PhotoBrowserConfiguration {
                override fun load(imageView: ImageView, url: String, onLoadStart: Function1<Boolean, Unit>, onLoadProgress: Function2<Float, Float, Unit>, onLoadEnd: Function1<Boolean, Unit>) {
                    loader.load(imageView, url, 0, 0, object : RNTPhotoBrowserListener {
                        override fun onLoadStart(hasProgress: Boolean) {
                            onLoadStart.invoke(hasProgress)
                        }

                        override fun onLoadProgress(loaded: Float, total: Float) {
                            onLoadProgress.invoke(loaded, total)
                        }

                        override fun onLoadEnd(success: Boolean) {
                            onLoadEnd.invoke(success)
                        }
                    })
                }

                override fun isLoaded(url: String, callback: Function1<Boolean, Unit>) {
                    loader.getImageCachePath(
                            url
                    ) { path ->
                        callback.invoke(path != "")
                    }
                }

                override fun save(url: String, drawable: Drawable): Boolean {

                    val fileName = URLUtil.guessFileName(url, null, null).toLowerCase()

                    var albumDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES)
                    if (albumName.isNotEmpty()) {
                        albumDir = File(albumDir, albumName)
                        if (!albumDir.exists()) {
                            albumDir.mkdir()
                        }
                    }

                    val filePath = albumDir.absolutePath + "/" + fileName
                    val image = File(filePath)
                    if (image.exists()) {
                        return true
                    }

                    try {
                        val outputStream = FileOutputStream(filePath)
                        if (drawable is BitmapDrawable) {
                            var format: Bitmap.CompressFormat = Bitmap.CompressFormat.JPEG

                            var extName = ""
                            val index = fileName.lastIndexOf(".")
                            if (index > 0) {
                                extName = fileName.substring(index + 1)
                            }

                            if (extName == ".png") {
                                format = Bitmap.CompressFormat.PNG
                            } else if (extName == ".webp") {
                                format = Bitmap.CompressFormat.WEBP
                            }

                            drawable.bitmap.compress(format, 100, outputStream)
                        } else {
                            val buffer = loader.getImageBuffer(drawable)
                            if (buffer != null) {
                                val bytes = ByteArray(buffer.capacity())
                                (buffer.duplicate().clear() as ByteBuffer).get(bytes)
                                outputStream.write(bytes, 0, bytes.size)
                            }
                        }

                        outputStream.close()

                        if (isScannerConnected!!) {
                            scanner.scanFile(filePath, "image/*")
                            return true
                        }

                    } catch (e: FileNotFoundException) {
                        Log.d("RNPhotoBrowser", "save photo FileNotFoundException $e")
                    } catch (e: Exception) {
                        Log.d("RNPhotoBrowser", "save photo Exception $e")
                    }

                    return false

                }
            }
        }
    }

}