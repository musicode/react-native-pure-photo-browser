package com.github.musicode.photobrowser;

import android.widget.ImageView;
import android.graphics.Bitmap
import android.graphics.drawable.Drawable

public interface RNTPhotoLoader {

    void load(ImageView imageView, String url, RNTPhotoListenr listenr);

    boolean isLoaded(String url);

    Bitmap getBitmap(Drawable drawable);

}
