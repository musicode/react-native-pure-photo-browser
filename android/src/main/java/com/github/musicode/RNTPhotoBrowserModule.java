
package com.github.musicode;

import android.graphics.Bitmap;
import android.widget.ImageView;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.WritableMap;
import com.github.herokotlin.photobrowser.PhotoBrowser;
import com.github.herokotlin.photobrowser.PhotoBrowserActivity;
import com.github.herokotlin.photobrowser.PhotoLoader;
import com.github.herokotlin.photobrowser.PhotoModel;

import org.jetbrains.annotations.NotNull;

import java.io.File;
import java.io.IOException;

import id.zelory.compressor.Compressor;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;

public class RNTPhotoBrowserModule extends ReactContextBaseJavaModule {

  private final ReactApplicationContext reactContext;

  public static void setPhotoLoader(final RNTPhotoLoader loader) {
      PhotoBrowser.loader = new PhotoLoader() {
          @Override
          public void load(@NotNull ImageView imageView, @NotNull String s, @NotNull PhotoModel photoModel, @NotNull Function1<? super Boolean, Unit> function1, @NotNull Function2<? super Float, ? super Float, Unit> function2, @NotNull Function1<? super Boolean, Unit> function11) {
                loader.load(imageView, s, function1, function2, function11);
          }

          @Override
          public void isLoaded(@NotNull String s, @NotNull Function1<? super Boolean, Unit> function1) {
              function1.invoke(false);
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
  public void openBrowser(int index, ReadableArray list) {

    String[] urls = new String[list.size()];

    list.toArrayList().toArray(urls);

    String[] rawList = new String[list.size()];
    for (Integer i = 0; i < rawList.length; i++) {
      rawList[i] = "";
    }

    PhotoBrowserActivity.Companion.newInstance(reactContext.getCurrentActivity(), index, urls, urls, rawList);
  }

  @ReactMethod
  public void compressImage(String src, String dest, Callback callback) {
      File file = new File(src);
      if (file.exists()) {
          try {
              File destFile = new File(dest);

              new Compressor(reactContext)
                      .setMaxWidth(1280)
                      .setMaxHeight(1280)
                      .setQuality(70)
                      .setCompressFormat(Bitmap.CompressFormat.JPEG)
                      .setDestinationDirectoryPath(destFile.getParent())
                      .compressToFile(file, destFile.getName());

              WritableMap map = Arguments.createMap();
              map.putString("path", dest);
              callback.invoke(null, map);
          }
          catch (IOException e) {
              callback.invoke("io error");
          }
      }
      else {
          callback.invoke("io error");
      }
  }

}