package com.example.info_scanner_mobile;

import android.animation.Animator;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Matrix;
import android.graphics.Paint;
import android.graphics.Path;
import android.graphics.PorterDuff;
import android.graphics.PorterDuffXfermode;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.support.annotation.DrawableRes;
import android.support.annotation.NonNull;
import android.support.v4.content.ContextCompat;
import android.view.View;
import android.view.ViewAnimationUtils;
import android.view.WindowInsets;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

import static android.view.ViewGroup.LayoutParams.MATCH_PARENT;

public class MainActivity extends FlutterActivity {
    public class ClippingView extends View {
        private Paint paint = new Paint();
        private Paint maskPaint = new Paint();;
        private Matrix matrix = new Matrix();

        private Bitmap hammer = BitmapFactory.decodeResource(getResources(), R.mipmap.hammer);
        private Bitmap stand = BitmapFactory.decodeResource(getResources(), R.mipmap.stand);

        private int x = 0;
        private int radius = 0;
        private int framesPerSecond = 60;

        private long animationDelay = 2000;
        private long hammerAnimationDuration = 1000;
        private long animationDuration = 3000 + hammerAnimationDuration;
        private long startTime;


        public ClippingView(Context context) {
            super(context);

            this.startTime = System.currentTimeMillis();
            this.postInvalidate();

            maskPaint.setXfermode(new PorterDuffXfermode(PorterDuff.Mode.CLEAR));
        }

        @Override
        public void onDraw(Canvas canvas) {
            super.onDraw(canvas);

            int w = canvas.getWidth();
            int h = canvas.getHeight();

            int imgW = (w - stand.getWidth())/2;
            int imgH = (h - stand.getHeight())/2;

            matrix.setRotate(-x, stand.getWidth(), stand.getHeight());
            matrix.postTranslate(imgW, imgH);
            canvas.drawBitmap(hammer, matrix, paint);
            canvas.drawBitmap(stand, imgW, imgH, paint);

            canvas.drawCircle(w/2, h/2, radius, maskPaint);

            long elapsedTime = System.currentTimeMillis() - startTime;
            if(elapsedTime < animationDelay) {
                //simple delay before animations
                this.postInvalidateDelayed(animationDelay);//1000 / framesPerSecond);
            } else {
                if(elapsedTime < animationDuration + animationDelay) {
                    //hammer animation
                    if (x < 10) {
                        x++;
                        this.postInvalidateDelayed(2000 / framesPerSecond);
                    } else {
                        radius += 200;
                        this.postInvalidateDelayed(1000 / framesPerSecond);
                    }
                } else {
                    setVisibility(View.GONE);
                }
            }
        }
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        ClippingView r = new ClippingView(this.getBaseContext());
        r.setBackgroundColor(ContextCompat.getColor(getApplicationContext(), R.color.mtsRed));
        this.addContentView(r, new LinearLayout.LayoutParams(MATCH_PARENT, MATCH_PARENT));

        GeneratedPluginRegistrant.registerWith(this);
    }
}
