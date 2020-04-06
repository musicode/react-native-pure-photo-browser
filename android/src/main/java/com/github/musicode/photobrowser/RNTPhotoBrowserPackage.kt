package com.github.musicode.photobrowser

import com.facebook.react.ReactPackage
import com.facebook.react.bridge.NativeModule
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.uimanager.ViewManager

class RNTPhotoBrowserPackage : ReactPackage {

    override fun createNativeModules(reactContext: ReactApplicationContext): List<NativeModule> {
        return listOf<NativeModule>(RNTPhotoBrowserModule(reactContext))
    }

    override fun createViewManagers(reactContext: ReactApplicationContext): List<ViewManager<*, *>> {
        return listOf<ViewManager<*, *>>(
                RNTThumbnailViewManager(reactContext),
                RNTPhotoBrowserManager(reactContext)
        )
    }

}