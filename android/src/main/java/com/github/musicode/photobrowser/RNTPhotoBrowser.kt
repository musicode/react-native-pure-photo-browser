package com.github.musicode.photobrowser

import android.view.Choreographer

import com.facebook.react.uimanager.ThemedReactContext
import com.github.herokotlin.photobrowser.PhotoBrowser

class RNTPhotoBrowser(reactContext: ThemedReactContext) : PhotoBrowser(reactContext) {

    private val frameCallback = object : Choreographer.FrameCallback {
        override fun doFrame(frameTimeNanos: Long) {
            for (i in 0 until childCount) {
                val child = getChildAt(i)
                child.measure(MeasureSpec.makeMeasureSpec(measuredWidth, MeasureSpec.EXACTLY),
                        MeasureSpec.makeMeasureSpec(measuredHeight, MeasureSpec.EXACTLY))
                child.layout(0, 0, child.measuredWidth, child.measuredHeight)
            }
            viewTreeObserver.dispatchOnGlobalLayout()
            Choreographer.getInstance().postFrameCallback(this)
        }
    }

    init {
        Choreographer.getInstance().postFrameCallback(frameCallback)
    }

    fun destroy() {
        Choreographer.getInstance().removeFrameCallback(frameCallback)
    }

}