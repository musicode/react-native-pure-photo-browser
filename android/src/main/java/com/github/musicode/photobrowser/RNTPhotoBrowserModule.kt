package com.github.musicode.photobrowser

import android.graphics.drawable.Drawable
import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod

class RNTPhotoBrowserModule(private val reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {

    override fun getName(): String {
        return "RNTPhotoBrowser"
    }

    @ReactMethod
    fun saveLocalPhoto(path: String, promise: Promise) {

        val drawable = Drawable.createFromPath(path)
        if (drawable == null) {
            promise.reject("1", "failed")
            return
        }

        if (RNTPhotoBrowserManager.configuration.save(path, drawable)) {
            promise.resolve(Arguments.createMap())
        }
        else {
            promise.reject("1", "failed")
        }

    }

}