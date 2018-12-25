package com.github.musicode.photobrowser;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.widget.ImageView;
import android.graphics.drawable.Drawable;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;
import com.github.herokotlin.photobrowser.PhotoBrowser;
import com.github.herokotlin.photobrowser.PhotoBrowserActivity;
import com.github.herokotlin.photobrowser.PhotoBrowserConfiguration;
import com.github.herokotlin.photobrowser.model.Photo;

import org.jetbrains.annotations.NotNull;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;

import id.zelory.compressor.Compressor;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;

public class RNTPhotoBrowserModule extends ReactContextBaseJavaModule {

    private final ReactApplicationContext reactContext;

    static RNTPhotoLoader photoLoader;

    public static void setPhotoLoader(final RNTPhotoLoader loader) {
        photoLoader = loader;

        PhotoBrowser.configuration = new PhotoBrowserConfiguration() {
            @Override
            public void load(@NotNull ImageView imageView, @NotNull String s, final @NotNull Function1<? super Boolean, Unit> function1, final @NotNull Function2<? super Float, ? super Float, Unit> function2, final @NotNull Function1<? super Boolean, Unit> function11) {
                loader.load(imageView, s, new RNTPhotoListenr() {
                    @Override
                    public void onLoadStart(boolean hasProgress) {
                        function1.invoke(hasProgress);
                    }

                    @Override
                    public void onLoadProgress(float loaded, float total) {
                        function2.invoke(loaded, total);
                    }

                    @Override
                    public void onLoadEnd(boolean success) {
                        function11.invoke(success);
                    }
                });
            }

            @Override
            public boolean isLoaded(@NotNull String s) {
                return loader.isLoaded(s);
            }

            @Override
            public boolean save(@NotNull String s, @NotNull Drawable drawable) {
                return loader.save(s, drawable);
            }
        };
    }

    public RNTPhotoBrowserModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    @Override
    public String getName() {
        return "RNTPhotoBrowser";
    }

    @ReactMethod
    public void openBrowser(ReadableArray list, int index, String indicator, int pageMargin) {

        ArrayList<Photo> photos = new ArrayList<Photo>();

        for (int i = 0; i < list.size(); i++) {
            photos.add(formatPhoto(list.getMap(i)));
        }

        PhotoBrowserActivity.Companion.newInstance(reactContext.getCurrentActivity(), photos, index, indicator, pageMargin);

    }

    @ReactMethod
    public void compressImage(String src, String dest, Callback callback) {
        File file = new File(src);
        if (file.exists()) {
            try {
                File destFile = new File(dest);

                File result = new Compressor(reactContext)
                        .setMaxWidth(2000)
                        .setMaxHeight(2000)
                        .setQuality(50)
                        .setCompressFormat(Bitmap.CompressFormat.JPEG)
                        .setDestinationDirectoryPath(destFile.getParent())
                        .compressToFile(file, destFile.getName());

                if (result.exists()) {
                    String path = result.getAbsolutePath();

                    BitmapFactory.Options options = new BitmapFactory.Options();
                    options.inJustDecodeBounds = true;
                    BitmapFactory.decodeFile(path, options);

                    WritableMap map = Arguments.createMap();
                    map.putString("path", path);
                    map.putInt("width", options.outWidth);
                    map.putInt("height", options.outHeight);

                    callback.invoke(null, map);
                    return;
                }
            }
            catch (IOException e) {

            }
        }
        callback.invoke("io error");
    }

    private Photo formatPhoto(ReadableMap data) {

        String thumbnailUrl = data.getString("thumbnailUrl");
        String highQualityUrl = data.getString("highQualityUrl");
        String rawUrl = data.getString("rawUrl");

        return new Photo(thumbnailUrl, highQualityUrl, rawUrl, false, false, false, false, 1f);

    }

}