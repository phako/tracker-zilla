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

internal class TrackerZilla.LinkedInfo : AbstractInfo {
    private const string linked_template = "SELECT ?a ?b WHERE { <%s> ?a ?b . }";

    public LinkedInfo (Sparql.Connection connection,
                       Gee.Set<string>   properties) {
        base (connection, properties);
    }

    public override string render () {
        if (data.size == 0) {
            return "";
        }

        string html = "<h3>Linked resources:</h3>\n" +
                      "<div>\n" +
                      "<table>\n";
        foreach (var key in this.data.get_keys ()) {
            foreach (var value in this.data.get (key)) {
                html += "<tr><td>%s</td><td>%s</td></tr>\n".printf (key, value);
            }
        }
        html += "</table>\n</div>";

        return html;
    }

    public override unowned string template () {
        return linked_template;
    }
}
