ACLOCAL_AMFLAGS = -I m4 ${ACLOCAL_FLAGS}

if UNINSTALLED
shareddir=$(abs_top_builddir)/data
ui_dir=$(abs_top_builddir)/data
else
shareddir=$(datadir)/tracker-zilla
ui_dir=$(shareddir)
endif

bin_PROGRAMS=src/trackerzilla

src_trackerzilla_SOURCES= \
	src/abstract-info.vala \
	src/data-source.vala \
	src/linked-info.vala \
	src/linking-info.vala \
	src/main.vala \
	src/main-window.vala \
	src/navigation-bar.vala \
	src/prefix-registry.vala \
	src/property-info.vala \
	src/search-bar.vala

src_trackerzilla_VALAFLAGS=\
	--vapidir $(abs_top_srcdir)/vapi \
	--pkg config \
	--pkg gio-2.0 \
	--pkg gtk+-3.0 \
	--pkg webkitgtk-3.0 \
	--pkg posix \
	--pkg gee-0.8 \
	--pkg $(TRACKER_SPARQL_PKG)

src_trackerzilla_CFLAGS=\
	-DUI_DIR='"$(ui_dir)"' \
	$(LIBGTK_CFLAGS) \
	$(WEBKITGTK_CFLAGS) \
	$(TRACKER_SPARQL_CFLAGS) \
	$(GEE_CFLAGS)

src_trackerzilla_LDADD=\
	$(LIBGTK_LIBS) \
	$(WEBKITGTK_LIBS) \
	$(TRACKER_SPARQL_LIBS) \
	$(GEE_LIBS)

dist_shared_DATA= \
	data/tracker-zilla.ui

