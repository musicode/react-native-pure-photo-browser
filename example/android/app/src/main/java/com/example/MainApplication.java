package com.example;

import android.app.Application;
import android.support.annotation.Nullable;
import android.widget.ImageView;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.DataSource;
import com.bumptech.glide.load.engine.GlideException;
import com.bumptech.glide.request.RequestListener;
import com.bumptech.glide.request.target.Target;
import com.facebook.react.ReactApplication;
import com.facebook.react.ReactNativeHost;
import com.facebook.react.ReactPackage;
import com.facebook.react.shell.MainReactPackage;
import com.facebook.soloader.SoLoader;
import com.github.musicode.RNTPhotoBrowserModule;
import com.github.musicode.RNTPhotoBrowserPackage;
import com.github.musicode.RNTPhotoLoader;

import org.jetbrains.annotations.NotNull;

import java.util.Arrays;
import java.util.List;

import kotlin.Unit;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;

public class MainApplication extends Application implements ReactApplication {

  private final ReactNativeHost mReactNativeHost = new ReactNativeHost(this) {
    @Override
    public boolean getUseDeveloperSupport() {
      return BuildConfig.DEBUG;
    }

    @Override
    protected List<ReactPackage> getPackages() {
      return Arrays.<ReactPackage>asList(
          new MainReactPackage(),
          new RNTPhotoBrowserPackage()
      );
    }

    @Override
    protected String getJSMainModuleName() {
      return "index";
    }
  };

  @Override
  public ReactNativeHost getReactNativeHost() {
    return mReactNativeHost;
  }

  @Override
  public void onCreate() {
    super.onCreate();
    SoLoader.init(this, /* native exopackage */ false);

    RNTPhotoBrowserModule.setPhotoLoader(new RNTPhotoLoader() {

      @Override
      public void load(ImageView imageView, String url, kotlin.jvm.functions.Function1<? super Boolean, kotlin.Unit> onLoadStart, final kotlin.jvm.functions.Function2<? super Float, ? super Float, kotlin.Unit> onLoadProgress, final kotlin.jvm.functions.Function1<? super Boolean, kotlin.Unit> onLoadEnd) {
        onLoadStart.invoke(false);

        Glide.with(imageView.getContext()).load(url).listener(new RequestListener() {
          @Override
          public boolean onLoadFailed(@Nullable GlideException e, Object model, Target target, boolean isFirstResource) {
            onLoadEnd.invoke(false);
            return false;
          }

          @Override
          public boolean onResourceReady(Object resource, Object model, Target target, DataSource dataSource, boolean isFirstResource) {
            onLoadEnd.invoke(true);
            return false;
          }
        }).into(imageView);
      }
    });

  }
}
