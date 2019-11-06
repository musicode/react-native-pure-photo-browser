package com.github.musicode.photobrowser

interface RNTPhotoBrowserListener {

    fun onLoadStart(hasProgress: Boolean)

    fun onLoadProgress(loaded: Float, total: Float)

    fun onLoadEnd(success: Boolean)

}