AC_PREREQ([2.64])
AC_INIT([TrackerZilla],
        [0.2],
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
GTK_REQUIRED=3.0
WEBKITGTK_REQUIRED=1.3.12
TRACKER_SPARQL_REQUIRED=0.10
GEE_REQUIRED=0.8

AC_ARG_ENABLE([uninstalled],
              AS_HELP_STRING([--enable-uninstalled],
                             [Run the program from source tree]),,
              enable_uninstalled=no)
AM_CONDITIONAL(UNINSTALLED, [test "x$enable_uninstalled" = "xyes"])

PKG_CHECK_MODULES(LIBGTK, gtk+-3.0 >= $GTK_REQUIRED)
PKG_CHECK_MODULES(WEBKITGTK, webkitgtk-3.0 >= $WEBKITGTK_REQUIRED)
PKG_CHECK_MODULES(GEE, gee-0.8 >= $GEE_REQUIRED)

# Search available Tracker version
trackerpkg=""
m4_foreach([VERSION], [[0.16] [0.15], [0.14], [0.11], [0.12], [0.10]],
                      [PKG_CHECK_EXISTS([tracker-sparql-VERSION >= 0.10.5],
                                        [ trackerpkg="tracker-sparql-VERSION" ])
                      ])

PKG_CHECK_MODULES([TRACKER_SPARQL], [ ${trackerpkg} ])
TRACKER_SPARQL_PKG=$trackerpkg
AC_SUBST(TRACKER_SPARQL_PKG)

AC_ARG_ENABLE([vala],
              AS_HELP_STRING([--enable-vala],
                             [enable regeneration from vala sources]),,
              enable_vala=no)

if test "x$enable_vala" = "xyes"
then
    AM_PROG_VALAC([$VALA_REQUIRED])
    dnl VALA_CHECK_PACKAGES([gtk+-3.0 tracker-sparql-0.14 gee-1.0])
fi

AC_CONFIG_FILES([Makefile])
AC_OUTPUT
