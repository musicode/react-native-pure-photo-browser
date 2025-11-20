package com.github.musicode.photobrowser

import android.graphics.Color

import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.annotations.ReactProp

class RNTThumbnailViewManager(private val reactContext: ReactApplicationContext) : SimpleViewManager<RNTThumbnailView>() {

    override fun getName(): String {
        return "RNTThumbnailView"
    }

    override fun createViewInstance(reactContext: ThemedReactContext): RNTThumbnailView {
        val view = RNTThumbnailView(reactContext)
        view.bgColor = Color.parseColor("#EBEBEB")
        return view
    }

    @ReactProp(name = "uri")
    fun setUri(view: RNTThumbnailView, uri: String) {
        view.uri = uri
        view.refreshIfNeeded()
    }

    @ReactProp(name = "width")
    fun setWidth(view: RNTThumbnailView, width: Int) {
        view.width = width
        view.refreshIfNeeded()
    }

    @ReactProp(name = "height")
    fun setHeight(view: RNTThumbnailView, height: Int) {
        view.height = height
        view.refreshIfNeeded()
    }

    @ReactProp(name = "borderRadius")
    fun setBorderRadius(view: RNTThumbnailView, borderRadius: Int) {
        view.borderRadius = borderRadius
    }

    override fun getExportedCustomBubblingEventTypeConstants(): MutableMap<String, Any> {
        val baseEventTypeConstants = super.getExportedCustomBubblingEventTypeConstants()
        val eventTypeConstants = baseEventTypeConstants ?: mutableMapOf()
        eventTypeConstants.putAll(
            mapOf(
                "onLoadStart" to mapOf("phasedRegistrationNames" to mapOf("bubbled" to "onLoadStart")),
                "onLoadProgress" to mapOf("phasedRegistrationNames" to mapOf("bubbled" to "onLoadProgress")),
                "onLoadEnd" to mapOf("phasedRegistrationNames" to mapOf("bubbled" to "onLoadEnd")),
            )
        )
        return eventTypeConstants
    }

}
