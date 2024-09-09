package pkg.myapp.myproxy;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Context;
import android.os.Build;
import android.os.Bundle;
import android.provider.Settings;
import android.util.Log;
import android.view.View;
import android.widget.Toast;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.Locale;

import peerproxyClientSdk.PeerproxyClientSdk;

public class MainActivity extends AppCompatActivity {
 private static String TAG = "myproxy";
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        runProxy();
        init();
    }

    private void init() {
        findViewById(R.id.btn).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                String url = "";
                url = peerproxyClientSdk.PeerproxyClientSdk.getPublicUrl();
                System.out.println("==================>"+url);
                Toast.makeText(MainActivity.this, "==================>"+url, Toast.LENGTH_LONG).show();
                //peerproxyClientSdk.PeerproxyClientSdk.disConnect();
            }
        });
    }

    private String getDeviceInfo() {
        JSONObject jsonDevice = new JSONObject();
        try {
            Context context = this.getApplicationContext();

            //（MANUFACTURER）
            String manufacturer = android.os.Build.MANUFACTURER;

            jsonDevice.put("manufacturer", manufacturer);

            //（BRAND）
            String brand = android.os.Build.BRAND;
            jsonDevice.put("brand", brand);
            //（BOARD）
            String board = android.os.Build.BOARD;
            jsonDevice.put("board", board);
            // （DEVICE）
            String device = android.os.Build.DEVICE;
            jsonDevice.put("device", device);
            //（MODEL）
            String model = android.os.Build.MODEL;
            jsonDevice.put("model", model);
            //（PRODUCT）
            String product = android.os.Build.PRODUCT;
            jsonDevice.put("product", product);
            //（FINGERPRINT）
            String fingerprint = android.os.Build.FINGERPRINT;
            jsonDevice.put("fingerprint", fingerprint);
            //（CPU_ABI）
            String cpuAbi = android.os.Build.CPU_ABI;
            jsonDevice.put("cpuAbi", cpuAbi);
            //（CPU_ABI2）
            String abi2 = android.os.Build.CPU_ABI2;
            jsonDevice.put("cpuAbi2", abi2);
            //（SERIAL）
            String serial = android.os.Build.ID;
            jsonDevice.put("serial", serial);

            jsonDevice.put("verion_release", Build.VERSION.RELEASE);
            jsonDevice.put("verion_SDKINT", Build.VERSION.SDK_INT);
            jsonDevice.put("verion_codename", Build.VERSION.CODENAME);
            jsonDevice.put("hardware", Build.HARDWARE);
            jsonDevice.put("locale", Locale.getDefault().toString());

        } catch (JSONException e) {
            e.printStackTrace();
        }

        return jsonDevice.toString();
    }

    private void runProxy() {
        new Thread(new Runnable() {
            @Override
            public void run() {
              while (true){
                  Log.d(TAG, "begin backgournd thread");
                  String serverAddr = "conn4.allproxy.io:9082";
                  Boolean enableHttp = true;
                  Boolean enableS5 = true;
                  String androidId = Settings.System.getString(getContentResolver(), Settings.Secure.ANDROID_ID);

                  String externalInfo = getDeviceInfo();
                  PeerproxyClientSdk.connectV2(
                          serverAddr,
                          enableHttp,
                          enableS5,
                          androidId,
                          "",
                          "",
                          externalInfo
                  );
                  Log.d(TAG, "connect failed");
                  try {
                      Thread.sleep(1000);
                  } catch (InterruptedException e) {
                      e.printStackTrace();
                  }
              }
            }
        }).start();
    }
}