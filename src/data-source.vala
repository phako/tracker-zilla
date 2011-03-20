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
    private AbstractInfo property;
    private Sparql.Connection connection;
    private Gee.HashMap<string, bool> properties;
    private KnownPrefixReplacer shortener;

    public signal void data_ready ();

    public DataSource () {
        this.properties = new Gee.HashMap<string, bool> ();
    }

    public async bool init_async (int          io_priority = GLib.Priority.DEFAULT,
                                  Cancellable? cancellable = null)
                                  throws Error {
        this.connection = yield Sparql.Connection.get_async ();
        this.shortener = new KnownPrefixReplacer (this.connection);

        var cursor = yield this.connection.query_async (TYPE_QUERY);
        var simple_type = new Regex ("^http://www.w3.org/2001/XMLSchema#");
        while (yield cursor.next_async ()) {
            properties.set (cursor.get_string (0),
                            simple_type.match (cursor.get_string (1)));
        }

        this.linked = new LinkedInfo (this.connection,
                                      this.properties,
                                      this.shortener);
        this.linking = new LinkingInfo (this.connection,
                                        this.properties,
                                        this.shortener);
        this.property = new PropertyInfo (this.connection,
                                          this.properties,
                                          this.shortener);

        yield this.shortener.init ();

        return true;
    }

    public async void query (string uri) throws Error {
        yield this.linked.query (uri);
        yield this.linking.query (uri);
        try {
            yield this.property.query (uri);
        } catch (Error error) {
            // ignore
        }
    }

    public async string render () {
        return "%s%s%s".printf (yield linked.render (),
                                yield linking.render (),
                                yield property.render ());
    }
}
