package com.github.musicode.photobrowser;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.drawable.BitmapDrawable;
import android.media.MediaScannerConnection;
import android.net.Uri;
import android.os.Environment;
import android.util.Log;
import android.webkit.URLUtil;
import android.widget.ImageView;
import android.graphics.drawable.Drawable;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.github.herokotlin.photobrowser.PhotoBrowser;
import com.github.herokotlin.photobrowser.PhotoBrowserActivity;
import com.github.herokotlin.photobrowser.PhotoBrowserConfiguration;
import com.github.herokotlin.photobrowser.model.Photo;

import org.jetbrains.annotations.NotNull;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.nio.ByteBuffer;
import java.util.ArrayList;

import kotlin.Unit;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;

public class RNTPhotoBrowserModule extends ReactContextBaseJavaModule {

    private final ReactApplicationContext reactContext;

    private static Boolean isScannerConnected = false;

    public static String albumName = "";

    static RNTPhotoLoader photoLoader;

    public static void setPhotoLoader(Context context, final RNTPhotoLoader loader) {

        photoLoader = loader;

        final MediaScannerConnection scanner = new MediaScannerConnection(context, new MediaScannerConnection.MediaScannerConnectionClient() {
            @Override
            public void onMediaScannerConnected() {
                isScannerConnected = true;
            }

            @Override
            public void onScanCompleted(String path, Uri uri) {

            }
        });

        scanner.connect();


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
            public boolean isLoaded(String url) {
                return loader.isLoaded(url);
            }

            @Override
            public boolean save(String url, Drawable drawable) {

                String fileName = URLUtil.guessFileName(url, null, null);

                File albumDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES);
                if (!albumName.isEmpty()) {
                    albumDir = new File(albumDir, albumName);
                    if (!albumDir.exists()) {
                        albumDir.mkdir();
                    }
                }

                String filePath = albumDir.getAbsolutePath() + "/" + fileName;
                File image = new File(filePath);
                if (image.exists()) {
                    return true;
                }

                try {
                    FileOutputStream outputStream = new FileOutputStream(filePath);
                    if (drawable instanceof BitmapDrawable) {
                        Bitmap.CompressFormat format = Bitmap.CompressFormat.JPEG;

                        String extName = "";
                        int index = fileName.lastIndexOf(".");
                        if (index > 0) {
                            extName = fileName.substring(index + 1);
                        }

                        if (extName.equals(".png")) {
                            format = Bitmap.CompressFormat.PNG;
                        }
                        else if (extName.equals(".webp")) {
                            format = Bitmap.CompressFormat.WEBP;
                        }

                        ((BitmapDrawable)drawable).getBitmap().compress(format, 100, outputStream);
                    }
                    else {
                        ByteBuffer buffer = loader.getBuffer(drawable);
                        if (buffer == null) {
                            return false;
                        }
                        byte[] bytes = new byte[buffer.capacity()];
                        ((ByteBuffer)buffer.duplicate().clear()).get(bytes);
                        outputStream.write(bytes, 0, bytes.length);
                    }

                    outputStream.close();

                    if (isScannerConnected) {
                        scanner.scanFile(filePath, "image/*");
                        return true;
                    }

                }
                catch (FileNotFoundException e) {
                    Log.d("RNPhotoBrowser", "save photo FileNotFoundException " + e);
                }
                catch (Exception e) {
                    Log.d("RNPhotoBrowser", "save photo Exception " + e);
                }

                return false;

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
    public void open(ReadableArray list, int index, String indicator, int pageMargin) {

        ArrayList<Photo> photos = new ArrayList<Photo>();

        for (int i = 0; i < list.size(); i++) {
            photos.add(formatPhoto(list.getMap(i)));
        }

        PhotoBrowserActivity.Companion.newInstance(reactContext.getCurrentActivity(), photos, index, indicator, pageMargin);

    }

    private Photo formatPhoto(ReadableMap data) {

        String thumbnailUrl = data.getString("thumbnailUrl");
        String highQualityUrl = data.getString("highQualityUrl");
        String rawUrl = data.getString("rawUrl");

        return new Photo(thumbnailUrl, highQualityUrl, rawUrl, false, false, false, false, 1f);

    }

}