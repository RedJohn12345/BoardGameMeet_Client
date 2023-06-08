package kkk.games.boardgm
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import com.yandex.mapkit.MapKitFactory

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        MapKitFactory.setLocale("ru_RU")
        MapKitFactory.setApiKey("e41e7611-70d8-49af-a99f-2a3043eebbce")// Your generated API key
        super.configureFlutterEngine(flutterEngine)
    }
}
