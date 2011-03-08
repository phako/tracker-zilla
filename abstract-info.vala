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

using Tracker;
using Gee;

internal abstract class TrackerZilla.AbstractInfo : Object {
    private const string LINK_TEMPLATE = "<a href=\"%s\">%s</a>";
    protected Sparql.Connection connection;
    protected TreeMultiMap<string,string> data;
    private   Gee.Set<string> properties;

    public static string generate_uri (string uri) {
        return "tracker://" + Uri.escape_string (uri, "", true);
    }

    public AbstractInfo (Sparql.Connection connection,
                         Gee.Set<string>   properties) {
        this.connection = connection;
        this.properties = properties;
        this.data = new TreeMultiMap<string, string> ();
    }

    public async void query (string urn) {
        try {
            this.data.clear ();
            var query = this.template ().printf (urn);
            var cursor = yield this.connection.query_async (query);
            while (yield cursor.next_async ()) {
                unowned string value = cursor.get_string (1);
                if (cursor.get_value_type (1) == Sparql.ValueType.URI ||
                    !this.properties.contains (cursor.get_string (0))) {
                    var link = LINK_TEMPLATE.printf (generate_uri (value),
                                                     value);
                    data[cursor.get_string (0)] = link;
                } else {
                    data[cursor.get_string (0)] = value;
                }
            }
        } catch (Error error) {
            warning ("Failed to query data: %s", error.message);
        }
    }

    public abstract string render ();

    public abstract unowned string template ();
}
