//
// Copyright 2011, Jens Georg <mail@jensge.org>
//
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
// 02110-1301, USA.
//

using Gtk;
using Gdk;
using Tracker;
using WebKit;

class TrackerZilla.Main : Object {
    private WebView view;
    private Builder builder;
    private SearchBar search_bar;
    private DataSource data_source;
    private unowned Gtk.Window window;

    public Main (string initial_uri) {
        this.data_source = new DataSource ();
        this.builder = new Builder ();

        try {
            this.builder.add_from_file (Config.UI_DIR + "/tracker-zilla.ui");
        } catch (Error error) {
            var dialog = new MessageDialog.with_markup
                                        (null,
                                         0,
                                         MessageType.ERROR,
                                         ButtonsType.CLOSE,
                                         "<b>Failed to create user interface:</b>");
            dialog.format_secondary_text (error.message);
            dialog.run ();
            dialog.destroy ();
            Posix.exit (2);
        }

        this.search_bar = new SearchBar (this.builder);
        window = this.builder.get_object ("tz_main_window") as Gtk.Window;

        this.setup_key_bindings ();

        // init UI
        this.view = new WebView ();
        this.view.show ();
        var scrolled = this.builder.get_object ("tz_main_scrolled")
                                        as ScrolledWindow;
        scrolled.add (view);

        window.destroy.connect ( () => { Gtk.main_quit (); } );

        this.search_bar.find.connect ( (text, direction) => {
            view.search_text (text,
                              false,
                              direction == SearchDirection.FORWARD,
                              true);
        });

        this.view.navigation_policy_decision_requested.connect
                                        (this.on_link_clicked);
        this.init (initial_uri);
    }

    public void run () {
        this.window.show ();

        Gtk.main ();
    }

    private async void init (string initial_uri) throws Error {
        try {
            yield this.data_source.init_async ();
            this.query (initial_uri);
        } catch (Error error) {
            this.show_error ("Failed to connect to tracker", error);
            Gtk.main_quit ();
        }
    }

    private bool on_link_clicked (WebFrame frame,
                                  NetworkRequest request,
                                  WebNavigationAction action,
                                  WebPolicyDecision decision) {
        bool history = true;

        if (action.get_reason () != WebKit.WebNavigationReason.LINK_CLICKED) {
            history = false;
        }

        if (request.uri.has_prefix ("tracker://")) {
            string resource = request.uri.slice (11, -1);
            this.query (resource, history);

            return true;
        }

        return false;
    }

    public async void query (string uri,
                             bool history = true)
                             throws Error {
        try {
            yield this.data_source.query (uri);
            var content = "<h2>%s</h2>%s".printf (uri,
                                                  this.data_source.render ());
            this.view.load_string (content, "text/html", "UTF-8", "");

            if (history) {
                var link = AbstractInfo.generate_uri (uri);
                var item = new WebHistoryItem.with_data (link, uri);

                this.view.get_back_forward_list ().add_item (item);
            }
        } catch (Error error) {
            this.show_error ("Failed to query information from tracker",
                             error);
            Gtk.main_quit ();
        }
    }

    private void setup_key_bindings () {
        this.window.add_accel_group (this.search_bar.get_accelerators ());
        var accelerators = new AccelGroup ();
        accelerators.connect (Key.Back,
                              0,
                              AccelFlags.VISIBLE,
                              this.on_back_key_pressed);

        accelerators.connect (Key.Left,
                              ModifierType.MOD1_MASK,
                              AccelFlags.VISIBLE,
                              this.on_back_key_pressed);

        accelerators.connect (Key.Forward,
                              0,
                              AccelFlags.VISIBLE,
                              this.on_forward_key_pressed);

        accelerators.connect (Key.Right,
                              ModifierType.MOD1_MASK,
                              AccelFlags.VISIBLE,
                              this.on_forward_key_pressed);

        this.window.add_accel_group (accelerators);
    }

    private void show_error (string primary, Error error) {
        var dialog = new MessageDialog.with_markup
                                    (this.window,
                                     0,
                                     MessageType.ERROR,
                                     ButtonsType.CLOSE,
                                     "<b>%s:</b>",
                                     primary);
        dialog.format_secondary_text (error.message);
        dialog.run ();
        dialog.destroy ();
    }

    private bool on_back_key_pressed (AccelGroup   accel_group,
                                      Object       acceleratable,
                                      uint         keyval,
                                      Gdk.ModifierType type) {
        if (this.view.can_go_back ()) {
            this.view.go_back ();
        }

        return true;
    }

    private bool on_forward_key_pressed (AccelGroup   accel_group,
                                         Object       acceleratable,
                                         uint         keyval,
                                         Gdk.ModifierType type) {
        if (this.view.can_go_forward ()) {
            this.view.go_forward ();
        }

        return true;
    }

}


