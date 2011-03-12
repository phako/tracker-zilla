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

internal class TrackerZilla.DataSource : Object, AsyncInitable {
    private const string TYPE_QUERY =
                 "SELECT ?p ?r WHERE { ?p a rdf:Property. ?p rdfs:range ?r }";
    private AbstractInfo linked;
    private AbstractInfo linking;
    private Sparql.Connection connection;
    private Gee.HashSet<string> simple_properties;
    private KnownPrefixReplacer shortener;

    public signal void data_ready ();

    public DataSource () {
        this.simple_properties = new Gee.HashSet<string> ();
    }

    public async bool init_async (int          io_priority = GLib.Priority.DEFAULT,
                                  Cancellable? cancellable = null)
                                  throws Error {
        this.connection = yield Sparql.Connection.get_async ();
        this.shortener = new KnownPrefixReplacer (this.connection);
        this.linked = new LinkedInfo (this.connection,
                                      this.simple_properties,
                                      this.shortener);
        this.linking = new LinkingInfo (this.connection,
                                        this.simple_properties,
                                        this.shortener);

        var cursor = yield this.connection.query_async (TYPE_QUERY);
        var simple_type = new Regex ("^http://www.w3.org/2001/XMLSchema#");
        while (yield cursor.next_async ()) {
            if (simple_type.match (cursor.get_string (1))) {
                simple_properties.add (cursor.get_string (0));
            }
        }

        yield this.shortener.init ();

        return true;
    }

    public async void query (string uri) {
        yield this.linked.query (uri);
        yield this.linking.query (uri);
    }

    public string render () {
        return "%s%s".printf (linked.render (),
                              linking.render ());
    }
}
