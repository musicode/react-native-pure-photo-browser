package com.github.musicode.photobrowser;

import android.widget.ImageView;
import android.graphics.drawable.Drawable;

public interface RNTPhotoLoader {

    boolean save(String url, Drawable drawable);

    void load(ImageView imageView, String url, RNTPhotoListenr listener);

    boolean isLoaded(String url);

}
