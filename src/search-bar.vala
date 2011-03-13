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
using Gdk;

internal enum TrackerZilla.SearchDirection {
    FORWARD,
    BACKWARD
}

internal class TrackerZilla.SearchBar : GLib.Object {
    private unowned Builder builder;
    private const string BAR = "tz_search_bar";
    private const string ENTRY = BAR + "_entry";
    private const string BACK = BAR + "_back_button";
    private const string FORWARD = BAR + "_forward_button";
    private const string CLOSE = BAR + "_close_button";
    private unowned Entry entry;
    private AccelGroup accelerators;

    public signal void find (string text, SearchDirection direction);

    public SearchBar (Builder builder) {
        this.builder = builder;
        this.setup_key_bindings ();

        this.entry = this.builder.get_object (ENTRY) as Entry;
        this.entry.icon_release.connect (this.search_forward);
        this.entry.activate.connect (this.search_forward);

        var forward = this.builder.get_object (FORWARD) as Button;
        forward.clicked.connect (this.search_forward);

        var back = this.builder.get_object (BACK) as Button;
        back.clicked.connect (() => {
            this.find (this.entry.get_text (), SearchDirection.BACKWARD);
        });

        var close = this.builder.get_object (CLOSE) as Button;
        close.clicked.connect (() => {
            this.show (false);
        });
    }

    private void setup_key_bindings () {
        this.accelerators = new AccelGroup ();
        this.accelerators.connect ('/', 0, AccelFlags.VISIBLE, () => {
            this.show ();

            return true;
        });

        this.accelerators.connect ('f', ModifierType.CONTROL_MASK,
                AccelFlags.VISIBLE, () => {
            this.show ();

            return true;
        });

        this.accelerators.connect (Key.Escape, 0, AccelFlags.VISIBLE, () => {
            this.show (false);

            return true;
        });
    }


    public void show (bool show = true) {
        var box = this.builder.get_object (BAR) as Box;

        box.set_visible (show);
        if (show) {
            this.entry.grab_focus ();
        }
    }

    public AccelGroup get_accelerators () {
        return this.accelerators;
    }

    private void search_forward () {
        this.find (this.entry.get_text (), SearchDirection.FORWARD);
    }
}
