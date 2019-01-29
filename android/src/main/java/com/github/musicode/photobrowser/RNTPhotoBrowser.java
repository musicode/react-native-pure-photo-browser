package com.github.musicode.photobrowser;

import android.view.Choreographer;
import android.view.View;

import com.facebook.react.uimanager.ThemedReactContext;
import com.github.herokotlin.photobrowser.PhotoBrowser;

class RNTPhotoBrowser extends PhotoBrowser {

    private Choreographer.FrameCallback frameCallback = new Choreographer.FrameCallback() {
        @Override
        public void doFrame(long frameTimeNanos) {
            for (int i = 0; i < getChildCount(); i++) {
                View child = getChildAt(i);
                child.measure(MeasureSpec.makeMeasureSpec(getMeasuredWidth(), MeasureSpec.EXACTLY),
                        MeasureSpec.makeMeasureSpec(getMeasuredHeight(), MeasureSpec.EXACTLY));
                child.layout(0, 0, child.getMeasuredWidth(), child.getMeasuredHeight());
            }
            getViewTreeObserver().dispatchOnGlobalLayout();
            Choreographer.getInstance().postFrameCallback(this);
        }
    };

    public RNTPhotoBrowser(ThemedReactContext reactContext) {
        super(reactContext);
        Choreographer.getInstance().postFrameCallback(frameCallback);
    }

    public void destroy() {
        Choreographer.getInstance().removeFrameCallback(frameCallback);
    }

}