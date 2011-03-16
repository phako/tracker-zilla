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

class TrackerZilla.NavigationBar : GLib.Object {
    private const int DIRECTION_BACK = -1;
    private const int DIRECTION_FORWARD = 1;
    private const string BAR = "tz_navigation_bar";
    private const string BACK = BAR + "_back_button";
    private const string FORWARD = BAR + "_forward_button";
    private const string ENTRY = BAR + "_property_entry";
    private Spinner spinner;
    private unowned Entry entry;

    public signal void open (string uri);
    public signal void navigate (int direction);

    public NavigationBar (Builder builder) {
        var box = builder.get_object (BAR) as Box;
        spinner = new Spinner ();
        spinner.show ();
        box.pack_end (spinner, false, false, 0);
        var back_button = builder.get_object (BACK) as Button;
        back_button.clicked.connect ( () => {
            this.navigate (DIRECTION_BACK);
        });

        var forward_button = builder.get_object (FORWARD) as Button;
        forward_button.clicked.connect ( () => {
            this.navigate (DIRECTION_FORWARD);
        });

        this.entry = builder.get_object (ENTRY) as Entry;
        entry.activate.connect ( () => {
            this.open (entry.get_text ());
        });
    }

    public void set_busy (bool busy = true) {
        if (busy) {
            this.spinner.start ();
        } else {
            this.spinner.stop ();
        }
    }

    public void set_uri (string uri) {
        this.entry.set_text (uri);
    }
}
