import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
    static Future<SharedPreferences> get _prefs async =>
        await SharedPreferences.getInstance();

    static Future<void> setFontSize(double fontSize) async {
        final prefs = await _prefs;
        await prefs.setDouble('fontSize', fontSize);
    }

    static Future<void> setFont(String font) async {
        final prefs = await _prefs;
        await prefs.setString('font', font);
    }

    static Future<void> setTheme(String theme) async {
        final prefs = await _prefs;
        await prefs.setString('theme', theme);
    }

    static Future<void> setTextView(bool value) async {
        final prefs = await _prefs;
        await prefs.setBool('textBoxMarker', value);
    }

    static Future<void> setLanguage(String language) async {
        final prefs = await _prefs;
        await prefs.setString('language', language);
    }

    static Future<double?> getFontSize() async {
        final prefs = await _prefs;
        return prefs.getDouble('fontSize');
    }

    static Future<String?> getFont() async {
        final prefs = await _prefs;
        return prefs.getString('font');
    }

    static Future<String?> getTheme() async {
        final prefs = await _prefs;
        return prefs.getString('theme');
    }

    static Future<bool?> getTextView() async {
        final prefs = await _prefs;
        return prefs.getBool('textBoxMarker');
    }

    static Future<String?> getLanguage() async {
        final prefs = await _prefs;
        return prefs.getString('language');
    }
}
