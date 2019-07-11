package com.example.info_scanner_mobile;

import android.app.Activity;
import android.app.ActivityOptions;
import android.content.Intent;
import android.graphics.drawable.AnimationDrawable;
import android.os.Bundle;
import android.os.Handler;
import android.view.animation.Animation;
import android.view.animation.LinearInterpolator;
import android.view.animation.RotateAnimation;
import android.widget.ImageView;

import static android.content.Intent.FLAG_ACTIVITY_REORDER_TO_FRONT;

public class SplashActivity extends Activity {
    private static final int ANIMATION_TIME_MS = 700;
    private static final int ANIMATION_START_OFFSET_MS = 400;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.splash_activity);

        ImageView view = findViewById(R.id.hammer);
        RotateAnimation anim = new RotateAnimation(
                0.0f,
                -10.0f,
                 Animation.RELATIVE_TO_SELF,
                1.0f,
                 Animation.RELATIVE_TO_SELF,
                1.0f);

        anim.setInterpolator(new LinearInterpolator());
        anim.setFillAfter(true);
        //anim.setRepeatCount(Animation.INFINITE);
        anim.setDuration(ANIMATION_TIME_MS);
        anim.setStartOffset(ANIMATION_START_OFFSET_MS);
        view.startAnimation(anim);

        anim.setAnimationListener(new Animation.AnimationListener() {
            @Override
            public void onAnimationStart(Animation animation) { }

            @Override
            public void onAnimationEnd(Animation animation) {
                /*Intent i = new Intent(SplashActivity.this, MainActivity.class);
                i.setFlags(i.getFlags() | Intent.FLAG_ACTIVITY_NEW_TASK);//FLAG_ACTIVITY_PREVIOUS_IS_TOP);//FLAG_ACTIVITY_REORDER_TO_FRONT);
                //moveTaskToBack(true);
                startActivity(i);*/
            }

            @Override
            public void onAnimationRepeat(Animation animation) { }
        });

        new Handler().postDelayed(() -> {
            Intent i = new Intent(SplashActivity.this, MainActivity.class);

            ActivityOptions options = ActivityOptions.makeCustomAnimation(this, R.anim.fade_in, 0);
            startActivity(i, options.toBundle());

            //i.setFlags(i.getFlags() | Intent.FLAG_ACTIVITY_NEW_TASK);//FLAG_ACTIVITY_PREVIOUS_IS_TOP);//FLAG_ACTIVITY_REORDER_TO_FRONT);
            //moveTaskToBack(true);
            //startActivity(i);
            finish();
        }, ANIMATION_START_OFFSET_MS + ANIMATION_TIME_MS);
    }
}