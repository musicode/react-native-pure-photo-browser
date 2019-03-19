package com.github.musicode.photobrowser;

public interface RNTPhotoBrowserListener {

    void onLoadStart(boolean hasProgress);

    void onLoadProgress(float loaded, float total);

    void onLoadEnd(boolean success);

}
