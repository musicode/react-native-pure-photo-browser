package com.github.musicode.photobrowser;

import android.widget.ImageView;
import android.graphics.drawable.Drawable;

import java.nio.ByteBuffer;

public interface RNTPhotoLoader {

    ByteBuffer getBuffer(Drawable drawable);

    boolean isLoaded(String url);

    void load(ImageView imageView, String url, RNTPhotoListenr listener);

}
