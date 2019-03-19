package com.github.musicode.photobrowser;

import android.content.Context;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.uimanager.events.RCTEventEmitter;
import com.github.herokotlin.photoview.ThumbnailView;

public class RNTThumbnailView extends ThumbnailView {

    int width = 0;

    int height = 0;

    String uri = "";

    public RNTThumbnailView(Context context) {
        super(context);
    }

    void refreshIfNeeded() {
        if (width > 0 && height > 0 && uri.length() > 0) {
            RNTPhotoBrowserManager.imageLoader.load(this, uri, width, height, new RNTPhotoBrowserListener() {
                @Override
                public void onLoadStart(boolean hasProgress) {
                    sendEvent("onLoadStart", null);
                }

                @Override
                public void onLoadProgress(float loaded, float total) {
                    WritableMap event = Arguments.createMap();
                    event.putInt("loaded", (int)loaded);
                    event.putInt("total", (int)total);
                    sendEvent("onLoadProgress", event);
                }

                @Override
                public void onLoadEnd(boolean success) {
                    WritableMap event = Arguments.createMap();
                    event.putBoolean("success", success);
                    sendEvent("onLoadEnd", event);
                }
            });
        }
    }

    void sendEvent(String name, WritableMap event) {
        ((ReactContext)getContext()).getJSModule(RCTEventEmitter.class).receiveEvent(getId(), name, event);
    }

}
