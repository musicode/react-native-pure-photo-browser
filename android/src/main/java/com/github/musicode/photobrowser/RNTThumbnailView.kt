package com.github.musicode.photobrowser

import android.content.Context

import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.ReactContext
import com.facebook.react.bridge.WritableMap
import com.facebook.react.uimanager.events.RCTEventEmitter
import com.github.herokotlin.photoview.ThumbnailView

class RNTThumbnailView(context: Context) : ThumbnailView(context) {

    internal var width = 0

    internal var height = 0

    internal var uri = ""

    internal fun refreshIfNeeded() {
        if (width > 0 && height > 0 && uri.isNotEmpty()) {
            RNTPhotoBrowserManager.imageLoader.loadImage(this, uri, width, height, object : RNTPhotoBrowserListener {
                override fun onLoadStart(hasProgress: Boolean) {
                    sendEvent("onLoadStart", null)
                }

                override fun onLoadProgress(loaded: Float, total: Float) {
                    val event = Arguments.createMap()
                    event.putInt("loaded", loaded.toInt())
                    event.putInt("total", total.toInt())
                    sendEvent("onLoadProgress", event)
                }

                override fun onLoadEnd(success: Boolean) {
                    val event = Arguments.createMap()
                    event.putBoolean("success", success)
                    sendEvent("onLoadEnd", event)
                }
            })
        }
    }

    internal fun sendEvent(name: String, event: WritableMap?) {
        (context as ReactContext).getJSModule(RCTEventEmitter::class.java).receiveEvent(id, name, event)
    }

}
