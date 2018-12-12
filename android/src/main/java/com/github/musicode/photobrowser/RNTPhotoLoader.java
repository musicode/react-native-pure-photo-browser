package com.github.musicode.photobrowser;

import android.widget.ImageView;

import org.jetbrains.annotations.NotNull;

import kotlin.Unit;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;

public interface RNTPhotoLoader {

    void load(ImageView imageView, String url, Function1<? super Boolean, Unit> onLoadStart, @NotNull Function2<? super Float, ? super Float, Unit> onLoadProgress, @NotNull Function1<? super Boolean, Unit> onLoadEnd);

}
