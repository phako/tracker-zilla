[CCode (cheader_filename = "config.h")]
public class Config {
    [CCode (cname = "UI_DIR")]
    public static const string UI_DIR;
}

[CCode (cheader_filename = "gdk/gdkkeysyms.h")]
public class Gdk.Key {
    [CCode (cname = "GDK_KEY_Escape")]
    public static const int Escape;
}
