package com.github.musicode.photobrowser;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.media.MediaScannerConnection;
import android.net.Uri;
import android.os.Environment;
import android.util.Log;
import android.view.View;
import android.webkit.URLUtil;
import android.widget.ImageView;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.common.MapBuilder;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.annotations.ReactProp;
import com.facebook.react.uimanager.events.RCTEventEmitter;
import com.github.herokotlin.photobrowser.PhotoBrowserCallback;
import com.github.herokotlin.photobrowser.PhotoBrowserConfiguration;
import com.github.herokotlin.photobrowser.model.Photo;

import org.jetbrains.annotations.NotNull;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.nio.ByteBuffer;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Nullable;

import kotlin.Unit;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;

public class RNTPhotoBrowserManager extends SimpleViewManager<RNTPhotoBrowser> {

    private static final int COMMAND_SAVE = 1;

    private static final int COMMAND_DETECT = 2;

    public static String albumName = "";

    private final ReactApplicationContext reactContext;

    private static Boolean isScannerConnected = false;

    static RNTPhotoBrowserLoader imageLoader;
    private static PhotoBrowserConfiguration configuration;

    public static void setImageLoader(Context context, final RNTPhotoBrowserLoader loader) {

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

        imageLoader = loader;

        configuration = new PhotoBrowserConfiguration() {
            @Override
            public void load(ImageView imageView, String url, final Function1<? super Boolean, Unit> onLoadStart, final Function2<? super Float, ? super Float, Unit> onLoadProgress, final Function1<? super Boolean, Unit> onLoadEnd) {
                loader.load(imageView, url, new RNTPhotoBrowserListenr() {
                    @Override
                    public void onLoadStart(boolean hasProgress) {
                        onLoadStart.invoke(hasProgress);
                    }

                    @Override
                    public void onLoadProgress(float loaded, float total) {
                        onLoadProgress.invoke(loaded, total);
                    }

                    @Override
                    public void onLoadEnd(boolean success) {
                        onLoadEnd.invoke(success);
                    }
                });
            }

            @Override
            public void isLoaded(String url, final Function1<? super Boolean, Unit> callback) {
                loader.getImageCachePath(
                    url,
                    new Function1<String, Unit>() {
                        @Override
                        public Unit invoke(String path) {
                            callback.invoke(path != null && !path.equals(""));
                            return null;
                        }
                    }
                );
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
                        ByteBuffer buffer = loader.getImageBuffer(drawable);
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


    public RNTPhotoBrowserManager(ReactApplicationContext reactContext) {
        super();
        this.reactContext = reactContext;
    }

    @Override
    public String getName() {
        return "RNTPhotoBrowser";
    }

    @Override
    protected RNTPhotoBrowser createViewInstance(ThemedReactContext reactContext) {
        final RNTPhotoBrowser view = new RNTPhotoBrowser(reactContext);
        view.configuration = configuration;
        view.callback = new PhotoBrowserCallback() {
            @Override
            public void onChange(@NotNull Photo photo, int i) {

                WritableMap map = Arguments.createMap();
                map.putString("thumbnailUrl", photo.getThumbnailUrl());
                map.putString("highQualityUrl", photo.getHighQualityUrl());
                map.putString("rawUrl", photo.getRawUrl());

                WritableMap event = Arguments.createMap();
                event.putInt("index", i);
                event.putMap("photo", map);

                sendMessage(view, "onChange", event);

            }

            @Override
            public void onTap(@NotNull Photo photo, int i) {

                WritableMap map = Arguments.createMap();
                map.putString("thumbnailUrl", photo.getThumbnailUrl());
                map.putString("highQualityUrl", photo.getHighQualityUrl());
                map.putString("rawUrl", photo.getRawUrl());
                map.putString("currentUrl", photo.getCurrentUrl());

                WritableMap event = Arguments.createMap();
                event.putInt("index", i);
                event.putMap("photo", map);

                sendMessage(view, "onTap", event);

            }

            @Override
            public void onLongPress(@NotNull final Photo photo, final int i) {

                imageLoader.getImageCachePath(
                        photo.getCurrentUrl(),
                        new Function1<String, Unit>() {
                            @Override
                            public Unit invoke(String path) {

                                WritableMap map = Arguments.createMap();
                                map.putString("thumbnailUrl", photo.getThumbnailUrl());
                                map.putString("highQualityUrl", photo.getHighQualityUrl());
                                map.putString("rawUrl", photo.getRawUrl());
                                map.putString("currentUrl", photo.getCurrentUrl());
                                map.putString("currentPath", path);

                                WritableMap event = Arguments.createMap();
                                event.putInt("index", i);
                                event.putMap("photo", map);

                                sendMessage(view, "onLongPress", event);

                                return null;
                            }
                        }
                );

            }

            @Override
            public void onSave(@NotNull Photo photo, int i, boolean b) {

                WritableMap map = Arguments.createMap();
                map.putString("thumbnailUrl", photo.getThumbnailUrl());
                map.putString("highQualityUrl", photo.getHighQualityUrl());
                map.putString("rawUrl", photo.getRawUrl());
                map.putString("currentUrl", photo.getCurrentUrl());

                WritableMap event = Arguments.createMap();
                event.putInt("index", i);
                event.putMap("photo", map);
                event.putBoolean("success", b);

                sendMessage(view, "onSave", event);

            }
        };
        return view;
    }

    @ReactProp(name = "indicator")
    public void setIndicator(final RNTPhotoBrowser view, int indicator) {
        if (indicator == 1) {
            view.setIndicator(RNTPhotoBrowser.IndicatorType.DOT);
        }
        else if (indicator == 2) {
            view.setIndicator(RNTPhotoBrowser.IndicatorType.NUMBER);
        }
        else {
            view.setIndicator(RNTPhotoBrowser.IndicatorType.NONE);
        }
    }

    @ReactProp(name = "pageMargin")
    public void setPageMargin(final RNTPhotoBrowser view, int pageMargin) {
        view.setPageMargin(pageMargin);
    }

    @ReactProp(name = "index")
    public void setIndex(final RNTPhotoBrowser view, int index) {
        view.setIndex(index);
    }

    @ReactProp(name = "list")
    public void setList(final RNTPhotoBrowser view, ReadableArray list) {

        List photos = new ArrayList<Photo>();

        for (int i = 0; i < list.size(); i++) {
            ReadableMap item = list.getMap(i);

            String thumbnailUrl = item.getString("thumbnailUrl");
            String highQualityUrl = item.getString("highQualityUrl");
            String rawUrl = item.getString("rawUrl");

            Photo photo = new Photo(thumbnailUrl, highQualityUrl, rawUrl, "", false, false, false, false, 1);
            photos.add(photo);
        }

        view.setPhotos(photos);

    }

    @Override
    public Map getExportedCustomBubblingEventTypeConstants() {
        return MapBuilder.builder()
                .put("onTap", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onTap")))
                .put("onLongPress", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onLongPress")))
                .put("onSave", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onSave")))
                .put("onChange", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onChange")))
                .put("onDetectResult", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onDetectResult")))
                .build();
    }

    @Override
    public @Nullable Map<String, Integer> getCommandsMap() {
        Map<String, Integer> commands = new HashMap<>();
        commands.put("save", COMMAND_SAVE);
        commands.put("detect", COMMAND_DETECT);
        return commands;
    }

    @Override
    public void receiveCommand(final RNTPhotoBrowser root, int commandId, @Nullable ReadableArray args) {
        switch (commandId) {
            case COMMAND_SAVE:
                root.saveImage();
                break;
            case COMMAND_DETECT:
                root.detectQRCode(
                    new Function1<String, Unit>() {
                        @Override
                        public Unit invoke(String s) {
                            WritableMap event = Arguments.createMap();
                            event.putString("text", s);
                            sendMessage(root, "onDetectResult", event);
                            return null;
                        }
                    }
                );
                break;
        }
    }

    @Override
    public void onDropViewInstance(RNTPhotoBrowser view) {
        super.onDropViewInstance(view);
        view.destroy();
    }

    private void sendMessage(View view, String name, WritableMap event) {
        reactContext.getJSModule(RCTEventEmitter.class).receiveEvent(view.getId(), name, event);
    }

}