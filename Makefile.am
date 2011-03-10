ACLOCAL_AMFLAGS = -I m4 ${ACLOCAL_FLAGS}

bin_PROGRAMS=src/trackerzilla

src_trackerzilla_SOURCES= \
	src/abstract-info.vala \
	src/linked-info.vala \
	src/linking-info.vala \
	src/main.vala \
	src/main-window.vala

src_trackerzilla_VALAFLAGS=\
	--vapidir $(abs_top_srcdir)/vapi \
	--pkg $(GTK_PACKAGE) \
	--pkg $(WEBKIT_PACKAGE) \
	--pkg gee-1.0 \
	--pkg tracker-sparql-0.10

src_trackerzilla_CFLAGS=\
	$(LIBGTK_CFLAGS) \
	$(WEBKITGTK_CFLAGS) \
	$(TRACKER_SPARQL_CFLAGS) \
	$(GEE_CFLAGS)

src_trackerzilla_LDFLAGS=\
	$(LIBGTK_LIBS) \
	$(WEBKITGTK_LIBS) \
	$(TRACKER_SPARQL_LIBS) \
	$(GEE_LIBS)


