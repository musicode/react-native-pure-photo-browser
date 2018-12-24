package com.github.musicode.photobrowser;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.common.MapBuilder;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.annotations.ReactProp;
import com.facebook.react.uimanager.events.RCTEventEmitter;
import com.github.herokotlin.photoview.ThumbnailView;

import java.util.Map;

public class RNTThumbnailViewManager extends SimpleViewManager<ThumbnailView> {

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
    protected ThumbnailView createViewInstance(ThemedReactContext reactContext) {
        return new ThumbnailView(reactContext);
    }

    @ReactProp(name = "uri")
    public void setUri(final ThumbnailView view, String uri) {

        final ReactContext context = (ReactContext)view.getContext();

        RNTPhotoBrowserModule.photoLoader.load(view, uri, new RNTPhotoListenr() {
            @Override
            public void onLoadStart(boolean hasProgress) {
                sendEvent(view,"onLoadStart", null);
            }

            @Override
            public void onLoadProgress(float loaded, float total) {
                WritableMap event = Arguments.createMap();
                event.putInt("loaded", (int)loaded);
                event.putInt("total", (int)total);
                sendEvent(view,"onLoadProgress", event);
            }

            @Override
            public void onLoadEnd(boolean success) {
                WritableMap event = Arguments.createMap();
                event.putBoolean("success", success);
                sendEvent(view,"onLoadEnd", event);
            }
        });
    }

    @ReactProp(name = "borderRadius")
    public void setBorderRadius(ThumbnailView view, int borderRadius) {
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

    private void sendEvent(ThumbnailView view, String name, WritableMap event) {
        ((ReactContext)view.getContext()).getJSModule(RCTEventEmitter.class).receiveEvent(view.getId(), name, event);
    }

}