package com.github.musicode.photobrowser

import android.widget.ImageView
import android.graphics.drawable.Drawable

import java.nio.ByteBuffer

interface RNTPhotoBrowserLoader {

    fun getImageBuffer(drawable: Drawable): ByteBuffer?

    fun getImageCachePath(url: String, callback: (String) -> Unit)

    fun load(imageView: ImageView, url: String, width: Int, height: Int, listener: RNTPhotoBrowserListener)

}
