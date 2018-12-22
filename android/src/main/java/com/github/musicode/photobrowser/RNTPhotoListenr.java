package com.github.musicode.photobrowser;

public interface RNTPhotoListenr {

    void onLoadStart(boolean hasProgress);

    void onLoadProgress(float loaded, float total);

    void onLoadEnd(boolean success);

}
