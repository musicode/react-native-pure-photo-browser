package com.github.musicode.photobrowser;

import android.graphics.Color;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.common.MapBuilder;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.annotations.ReactProp;

import java.util.Map;

public class RNTThumbnailViewManager extends SimpleViewManager<RNTThumbnailView> {

    private final ReactApplicationContext reactContext;

    public RNTThumbnailViewManager(ReactApplicationContext reactContext) {
        super();
        this.reactContext = reactContext;
    }

    @Override
    public String getName() {
        return "RNTThumbnailView";
    }

    @Override
    protected RNTThumbnailView createViewInstance(ThemedReactContext reactContext) {
        RNTThumbnailView view = new RNTThumbnailView(reactContext);
        view.setBgColor(Color.parseColor("#EBEBEB"));
        return view;
    }

    @ReactProp(name = "uri")
    public void setUri(final RNTThumbnailView view, String uri) {
        view.uri = uri;
        view.refreshIfNeeded();
    }

    @ReactProp(name = "width")
    public void setWidth(final RNTThumbnailView view, int width) {
        view.width = width;
        view.refreshIfNeeded();
    }

    @ReactProp(name = "height")
    public void setHeight(final RNTThumbnailView view, int height) {
        view.height = height;
        view.refreshIfNeeded();
    }

    @ReactProp(name = "borderRadius")
    public void setBorderRadius(RNTThumbnailView view, int borderRadius) {
        view.setBorderRadius(borderRadius);
    }

    @Override
    public Map getExportedCustomBubblingEventTypeConstants() {
        return MapBuilder.builder()
                .put("onLoadStart", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onLoadStart")))
                .put("onLoadProgress", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onLoadProgress")))
                .put("onLoadEnd", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onLoadEnd")))
                .build();
    }

}