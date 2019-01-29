package com.github.musicode.photobrowser;

public interface RNTPhotoBrowserListenr {

    void onLoadStart(boolean hasProgress);

    void onLoadProgress(float loaded, float total);

    void onLoadEnd(boolean success);

}
