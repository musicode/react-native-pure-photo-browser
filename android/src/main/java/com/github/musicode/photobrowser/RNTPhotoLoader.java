package com.github.musicode.photobrowser;

import android.widget.ImageView;

public interface RNTPhotoLoader {

    boolean isLoaded(String url);

    void load(ImageView imageView, String url, RNTPhotoListenr listenr);

}
