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
    protected const string LINK_TEMPLATE = "<a href=\"%s\">%s</a>";
    protected Sparql.Connection connection;
    protected TreeMultiMap<string,string> data;
    protected KnownPrefixReplacer shortener;
    protected Map<string, bool> properties;

    public static string generate_uri (string uri) {
        return "tracker://" + Uri.escape_string (uri, "", true);
    }

    public AbstractInfo (Sparql.Connection     connection,
                         Gee.Map<string, bool> properties,
                         KnownPrefixReplacer   shortener) {
        this.connection = connection;
        this.properties = properties;
        this.data = new TreeMultiMap<string, string> ();
        this.shortener = shortener;
    }

    public async void query (string urn) throws Error {
        var resolved_iri = this.shortener.reverse_lookup (urn);
        this.data.clear ();
        var query = this.template ().printf (resolved_iri);
        var cursor = yield this.connection.query_async (query);
        while (yield cursor.next_async ()) {
            unowned string predicate = cursor.get_string (0);
            unowned string object = cursor.get_string (1);
            this.generate_links (urn, predicate, object);
        }
    }

    public virtual void generate_links (string urn,
                                        string predicate,
                                        string object) {
        var shortened_predicate = this.shortener.reduce (predicate);
        var shortened_object = this.shortener.reduce (object);
        if (!this.properties.has (predicate, true)) {
            var link = LINK_TEMPLATE.printf (generate_uri (object),
                    shortened_object);
            data[shortened_predicate] = link;
        } else {
            data[shortened_predicate] = object;
        }
    }

    public abstract unowned string title ();

    public abstract bool is_swapped ();

    public abstract unowned string template ();

    public async string render () {
        if (data.size == 0) {
            return "";
        }

        StringBuilder html = new StringBuilder ();
        html.append ("<h3>");
        html.append (this.title ());
        html.append ("</h3>\n<div>\n<table>\n");

        unowned Thread<void *> t = Thread.create<void *> ( () => {
            var swapped = this.is_swapped ();
            foreach (var key in this.data.get_keys ()) {
                foreach (var value in this.data.get (key)) {
                    html.append ("<tr><td>");
                    html.append (swapped ? value : key);
                    html.append ("</td><td>");
                    html.append (swapped ? key : value);
                    html.append ("</td></tr>\n");
                }
            }

            Idle.add ( () => {
                render.callback ();

                return false;
            });

            return null;
        }, true);

        yield;

        t.join ();
        html.append ("</table>\n</div>");

        return html.str;

    }
}
