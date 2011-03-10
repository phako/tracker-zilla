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
using WebKit;

class TrackerZilla.MainWindow : Gtk.Window {
    private const string TYPE_QUERY =
                 "SELECT ?p ?r WHERE { ?p a rdf:Property. ?p rdfs:range ?r }";
    private WebView view;
    private AbstractInfo linked;
    private AbstractInfo linking;
    private Sparql.Connection connection;
    private Gee.HashSet<string> simple_properties;

    public MainWindow (string initial_uri) {
        Object (type: Gtk.WindowType.TOPLEVEL);

        // init UI
        this.view = new WebView ();
        var scrolled = new Gtk.ScrolledWindow (null, null);
        this.add (scrolled);
        scrolled.add (view);
        this.set_default_size (800, 600);

        this.destroy.connect ( () => { Gtk.main_quit (); } );

        try {
            this.connection = Sparql.Connection.get ();
            this.simple_properties = new Gee.HashSet<string> ();
            this.linked = new LinkedInfo (connection, simple_properties);
            this.linking = new LinkingInfo (connection, simple_properties);

            Idle.add (() => {
                this.init (initial_uri);

                return false;
            });

            this.view.navigation_policy_decision_requested.connect
                                        (this.on_link_clicked);
        } catch (Error error) {
            warning ("Could not connect to tracker: %s", error.message);
        }
    }

    private async void init (string initial_uri) {
        try {
            var cursor = yield connection.query_async (TYPE_QUERY);
            var simple_type = new Regex ("^http://www.w3.org/2001/XMLSchema#");

            while (yield cursor.next_async ()) {
                if (simple_type.match (cursor.get_string (1))) {
                    simple_properties.add (cursor.get_string (0));
                }
            }

            this.query (initial_uri);
        } catch (Error error) {
            warning ("Failed to initialize ourselves: %s", error.message);
        }
    }

    private bool on_link_clicked (WebFrame frame,
                                  NetworkRequest request,
                                  WebNavigationAction action,
                                  WebPolicyDecision decision) {
        bool history = true;

        if (action.get_reason () != WebKit.WebNavigationReason.LINK_CLICKED) {
            history = false;
        }

        if (request.uri.has_prefix ("tracker://")) {
            string resource = request.uri.slice (11, -1);
            this.query (resource, history);

            return true;
        }

        return false;
    }

    public async void query (string uri, bool history = true) {
        yield this.linked.query (uri);
        yield this.linking.query (uri);
        var content = "<h2>%s</h2>%s%s".printf (uri,
                                                linked.render (),
                                                linking.render ());
        this.view.load_html_string (content, "");
        if (history) {
            var item = new WebHistoryItem.with_data
                                        (AbstractInfo.generate_uri (uri),
                                         uri);

            this.view.get_back_forward_list ().add_item (item);
        }
    }
}


