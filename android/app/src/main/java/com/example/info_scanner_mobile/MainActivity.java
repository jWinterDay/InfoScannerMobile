package com.example.info_scanner_mobile;

import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

//channel test
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    //channel test
    new MethodChannel(getFlutterView(), "app_settings").setMethodCallHandler(
      new MethodChannel.MethodCallHandler() {
        @Override
        public void onMethodCall(MethodCall call, MethodChannel.Result result) {
          if (call.method.equals("test")) {
            String greetings = test();
            result.success(greetings);
          }
        }
      }
    );
  }

  private String test() {
    return "Hello from Native Android Code";
  }
}
