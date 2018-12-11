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
      public void load(ImageView imageView, String url, Function1<? super Boolean, Unit> function1, @NotNull Function2<? super Float, ? super Float, Unit> function2, @NotNull final Function1<? super Boolean, Unit> function11) {

        function1.invoke(false);

        Glide.with(imageView.getContext()).load(url).listener(new RequestListener() {
          @Override
          public boolean onLoadFailed(@Nullable GlideException e, Object model, Target target, boolean isFirstResource) {
            function11.invoke(false);
            return false;
          }

          @Override
          public boolean onResourceReady(Object resource, Object model, Target target, DataSource dataSource, boolean isFirstResource) {
            function11.invoke(true);
            return false;
          }
        }).into(imageView);

      }
    });

  }
}
