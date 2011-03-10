AC_PREREQ([2.64])
AC_INIT([TrackerZilla],
        [0.1],
        [http://jensge.org],
        [trackerzilla],
        [http://jensge.org])
AC_CONFIG_AUX_DIR([build-aux])

AC_CONFIG_SRCDIR([src/main.vala])
AC_CONFIG_HEADERS([config.h])
AC_CONFIG_MACRO_DIR([m4])

dnl Init automake
AM_INIT_AUTOMAKE([1.11.1 dist-bzip2])
AM_MAINTAINER_MODE([enable])
AM_SILENT_RULES([yes])

AC_PROG_CC
AM_PROG_CC_C_O

dnl Required packages
VALA_REQUIRED=0.11.6
GTK_PACKAGE=gtk+-3.0
GTK_REQUIRED=3.0
WEBKIT_PACKAGE=webkitgtk-3.0
WEBKITGTK_REQUIRED=1.3.12
TRACKER_SPARQL_REQUIRED=0.10
GEE_REQUIRED=0.6

AC_ARG_WITH([gtk],
            AS_HELP_STRING([--with-gtk],[The Gtk+ version to build with (2 or 3, default is 3)]),
            with_gtkver="$withval", with_gtkver=3)
case "${with_gtkver}" in
    2) GTK_PACKAGE=gtk+-2.0
       GTK_REQUIRED=2.23.4
       WEBKIT_PACKAGE=webkit-1.0
       WEBKITGTK_REQUIRED=1.2.5
       ;;
    *) ;;
esac
AC_SUBST([WEBKIT_PACKAGE])
AC_SUBST([GTK_PACKAGE])

PKG_CHECK_MODULES(LIBGTK, $GTK_PACKAGE >= $GTK_REQUIRED)
PKG_CHECK_MODULES(WEBKITGTK, $WEBKIT_PACKAGE >= $WEBKITGTK_REQUIRED)
PKG_CHECK_MODULES(TRACKER_SPARQL, tracker-sparql-0.10 >= $TRACKER_SPARQL_REQUIRED)
PKG_CHECK_MODULES(GEE, gee-1.0 >= $GEE_REQUIRED)

AC_ARG_ENABLE([vala],
              AS_HELP_STRING([--enable-vala],
                             [enable regeneration from vala sources]),,
              enable_vala=no)

if test "x$enable_vala" = "xyes"
then
    AM_PROG_VALAC([$VALA_REQUIRED])
    VALA_CHECK_PACKAGES([$GTK_PACKAGE tracker-sparql-0.10 gee-1.0])
fi

AC_CONFIG_FILES([Makefile])
AC_OUTPUT
