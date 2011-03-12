[CCode (cheader_filename = "config.h")]
public class Config {
    [CCode (cname = "UI_DIR")]
    public static const string UI_DIR;
}

[CCode (cheader_filename = "gdk/gdkkeysyms.h")]
public class Gdk.Key {
    [CCode (cname = "GDK_KEY_Escape")]
    public static const int Escape;

    [CCode (cname = "GDK_KEY_Back")]
    public static const int Back;

    [CCode (cname = "GDK_KEY_Forward")]
    public static const int Forward;

    [CCode (cname = "GDK_KEY_Left")]
    public static const int Left;

    [CCode (cname = "GDK_KEY_Right")]
    public static const int Right;
}
