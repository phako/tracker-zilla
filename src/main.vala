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

int main(string[] args) {
    Gtk.init (ref args);
    string resource = "http://www.w3.org/2000/01/rdf-schema#Resource";

    if (args.length > 1) {
        resource = args[1];
    }

    var m = new TrackerZilla.MainWindow (resource);
    m.show_all ();

    Gtk.main ();

    return 0;
}
