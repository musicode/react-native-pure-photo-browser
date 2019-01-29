package com.github.musicode.photobrowser;

import android.widget.ImageView;
import android.graphics.drawable.Drawable;

import java.nio.ByteBuffer;

import kotlin.Unit;
import kotlin.jvm.functions.Function1;

public interface RNTPhotoBrowserLoader {

    ByteBuffer getImageBuffer(Drawable drawable);

    void getImageCachePath(String url, Function1<String, Unit> callback);

    void load(ImageView imageView, String url, int width, int height, RNTPhotoBrowserListenr listener);

}
