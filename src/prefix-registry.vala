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

using Gee;
using Tracker;

internal class TrackerZilla.ReplacerEntry : Object {
    private string alias;
    private string prefix;

    public ReplacerEntry (string prefix, string short_alias) {
        this.prefix = prefix;
        this.alias = short_alias + ":";
    }

    public string? shorten (string uri) {
        if (uri.has_prefix (this.prefix)) {
            return this.alias + uri.substring (prefix.length);
        }

        return null;
    }

    public string? reverse_lookup (string prefixed_name) {
        if (prefixed_name.has_prefix (this.alias)) {
            return this.prefix + prefixed_name.substring (this.alias.length);
        }

        return null;
    }
}

internal class TrackerZilla.KnownPrefixReplacer : Object {
    private ArrayList<ReplacerEntry> entries;
    private Sparql.Connection connection;
    const string QUERY = "SELECT ?ns ?p WHERE { ?ns a tracker:Namespace; tracker:prefix ?p}";

    public KnownPrefixReplacer (Sparql.Connection connection) {
        this.entries = new ArrayList<ReplacerEntry> ();
        this.connection = connection;
    }

    public async void init () throws Error {
        var cursor = yield connection.query_async (QUERY);

        while (cursor.next ()) {
            this.entries.add (new ReplacerEntry (cursor.get_string (0),
                                                 cursor.get_string (1)));
        }
    }

    public string reduce (string uri) {
        foreach (var entry in this.entries) {
            var reduced = entry.shorten (uri);
            if (reduced != null) {
                return reduced;
            }
        }

        return uri;
    }

    public string reverse_lookup (string prefixed_name) {
        foreach (var entry in this.entries) {
            var expanded = entry.reverse_lookup (prefixed_name);
            if (expanded != null) {
                return expanded;
            }
        }

        return prefixed_name;
    }
}

