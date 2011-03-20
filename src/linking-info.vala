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

internal class TrackerZilla.LinkingInfo : AbstractInfo {
    private const string linking_template = "SELECT ?b ?a WHERE { ?a ?b <%s> . }";

    public LinkingInfo (Sparql.Connection     connection,
                        Gee.Map<string, bool> properties,
                        KnownPrefixReplacer   shortener) {
        base (connection, properties, shortener);
    }

    public override unowned string title () {
        return "Linking resources";
    }

    public override bool is_swapped () {
        return true;
    }

    public override unowned string template () {
        return linking_template;
    }
}
