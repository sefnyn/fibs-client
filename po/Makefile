# Makefile for program source directory in GNU NLS utilities package.
# Copyright (C) 1995, 1996, 1997 by Ulrich Drepper <drepper@gnu.ai.mit.edu>
# Copyright (C) 2004-2008 Rodney Dawes <dobey.pwns@gmail.com>
#
# This file may be copied and used freely without restrictions.  It may
# be used in projects which are not available under a GNU Public License,
# but which still want to provide support for the GNU gettext functionality.
#
# - Modified by Owen Taylor <otaylor@redhat.com> to use GETTEXT_PACKAGE
#   instead of PACKAGE and to look for po2tbl in ./ not in intl/
#
# - Modified by jacob berkman <jacob@ximian.com> to install
#   Makefile.in.in and po2tbl.sed.in for use with glib-gettextize
#
# - Modified by Rodney Dawes <dobey.pwns@gmail.com> for use with intltool
#
# We have the following line for use by intltoolize:
# INTLTOOL_MAKEFILE

GETTEXT_PACKAGE = gibbon
PACKAGE = gibbon
VERSION = 0.2.0

SHELL = /bin/bash

srcdir = .
top_srcdir = ..
top_builddir = ..


prefix = /usr/local
exec_prefix = ${prefix}
datadir = ${datarootdir}
datarootdir = ${prefix}/share
libdir = ${exec_prefix}/lib
localedir = ${datarootdir}/locale
subdir = po
install_sh = ${SHELL} /home/ns/good/fibs-client/install-sh
# Automake >= 1.8 provides $(MKDIR_P).
# Until it can be supposed, use the safe fallback:
mkdir_p = $(install_sh) -d

INSTALL = /bin/install -c
INSTALL_DATA = ${INSTALL} -m 644

GMSGFMT = /bin/msgfmt
MSGFMT = /bin/msgfmt
XGETTEXT = /bin/xgettext
INTLTOOL_UPDATE = /bin/intltool-update
INTLTOOL_EXTRACT = /bin/intltool-extract
MSGMERGE = INTLTOOL_EXTRACT="$(INTLTOOL_EXTRACT)" XGETTEXT="$(XGETTEXT)" srcdir=$(srcdir) $(INTLTOOL_UPDATE) --gettext-package $(GETTEXT_PACKAGE) --dist
GENPOT   = INTLTOOL_EXTRACT="$(INTLTOOL_EXTRACT)" XGETTEXT="$(XGETTEXT)" srcdir=$(srcdir) $(INTLTOOL_UPDATE) --gettext-package $(GETTEXT_PACKAGE) --pot

ALL_LINGUAS = 

PO_LINGUAS=$(shell if test -r $(srcdir)/LINGUAS; then grep -v "^\#" $(srcdir)/LINGUAS; else echo "$(ALL_LINGUAS)"; fi)

USER_LINGUAS=$(shell if test -n "$(LINGUAS)"; then LLINGUAS="$(LINGUAS)"; ALINGUAS="$(ALL_LINGUAS)"; for lang in $$LLINGUAS; do if test -n "`grep \^$$lang$$ $(srcdir)/LINGUAS 2>/dev/null`" -o -n "`echo $$ALINGUAS|tr ' ' '\n'|grep \^$$lang$$`"; then printf "$$lang "; fi; done; fi)

USE_LINGUAS=$(shell if test -n "$(USER_LINGUAS)" -o -n "$(LINGUAS)"; then LLINGUAS="$(USER_LINGUAS)"; else if test -n "$(PO_LINGUAS)"; then LLINGUAS="$(PO_LINGUAS)"; else LLINGUAS="$(ALL_LINGUAS)"; fi; fi; for lang in $$LLINGUAS; do printf "$$lang "; done)

POFILES=$(shell LINGUAS="$(PO_LINGUAS)"; for lang in $$LINGUAS; do printf "$$lang.po "; done)

DISTFILES = Makefile.in.in POTFILES.in $(POFILES)
EXTRA_DISTFILES = ChangeLog POTFILES.skip Makevars LINGUAS

POTFILES = \
	../data/bg.gibbon.gschema.xml.in \
	../data/gibbon.desktop.in \
	../data/gibbon.desktop.in.in \
	../data/gibbon.ui \
	../libgsgf/gsgf-collection.c \
	../libgsgf/gsgf-color.c \
	../libgsgf/gsgf-component.c \
	../libgsgf/gsgf-compose.c \
	../libgsgf/gsgf-cooked-value.c \
	../libgsgf/gsgf-date.c \
	../libgsgf/gsgf-double.c \
	../libgsgf/gsgf-empty.c \
	../libgsgf/gsgf-error.c \
	../libgsgf/gsgf-flavor-backgammon.c \
	../libgsgf/gsgf-flavor.c \
	../libgsgf/gsgf-game-tree.c \
	../libgsgf/gsgf-list-of.c \
	../libgsgf/gsgf-move-backgammon.c \
	../libgsgf/gsgf-move.c \
	../libgsgf/gsgf-node.c \
	../libgsgf/gsgf-number.c \
	../libgsgf/gsgf-point-backgammon.c \
	../libgsgf/gsgf-point.c \
	../libgsgf/gsgf-property.c \
	../libgsgf/gsgf-raw.c \
	../libgsgf/gsgf-real.c \
	../libgsgf/gsgf-result.c \
	../libgsgf/gsgf-simple-text.c \
	../libgsgf/gsgf-stone-backgammon.c \
	../libgsgf/gsgf-stone.c \
	../libgsgf/gsgf-text.c \
	../libgsgf/gsgf-util.c \
	../libgsgf/gsgf-value.c \
	../libgsgf/libgsgf.c \
	../libgsgf/tests/test-empty.c \
	../libgsgf/tests/test-non-unique-points.c \
	../libgsgf/tests/test-number.c \
	../libgsgf/tests/test-real.c \
	../libgsgf/tests/test-really-empty.c \
	../libgsgf/tests/test-write-empty.c \
	../src/gibbon-accept.c \
	../src/gibbon-analysis-view.c \
	../src/gibbon-analysis-move.c \
	../src/gibbon-app.c \
	../src/gibbon-archive.c \
	../src/gibbon-board.c \
	../src/gibbon.c \
	../src/gibbon-cairoboard.c \
	../src/gibbon-chat.c \
	../src/gibbon-chat-view.c \
	../src/gibbon-client-icons.c \
	../src/gibbon-clip-lexer.c \
	../src/gibbon-clip-reader.c \
	../src/gibbon-connection.c \
	../src/gibbon-connection-dialog.c \
	../src/gibbon-convert.c \
	../src/gibbon-country.c \
	../src/gibbon-database.c \
	../src/gibbon-double.c \
	../src/gibbon-drop.c \
	../src/gibbon-fibs-command.c \
	../src/gibbon-fibs-message.c \
	../src/gibbon-game-action.c \
	../src/gibbon-game.c \
	../src/gibbon-game-chat.c \
	../src/gibbon-geo-ip-updater.c \
	../src/gibbon-gmd-lexer.c \
	../src/gibbon-gmd-lexer.l \
	../src/gibbon-gmd-parser.c \
	../src/gibbon-gmd-parser.y \
	../src/gibbon-gmd-reader.c \
	../src/gibbon-gmd-writer.c \
	../src/gibbon-help.c \
	../src/gibbon-inviter-list.c \
	../src/gibbon-inviter-list-view.c \
	../src/gibbon-java-fibs-importer.c \
	../src/gibbon-java-fibs-lexer.c \
	../src/gibbon-java-fibs-lexer.l \
	../src/gibbon-java-fibs-parser.c \
	../src/gibbon-java-fibs-parser.y \
	../src/gibbon-java-fibs-reader.c \
	../src/gibbon-java-fibs-writer.c \
	../src/gibbon-jelly-fish-lexer.l \
	../src/gibbon-jelly-fish-parser.c \
	../src/gibbon-jelly-fish-parser.y \
	../src/gibbon-jelly-fish-reader.c \
	../src/gibbon-jelly-fish-writer.c \
	../src/gibbon-match.c \
	../src/gibbon-match-list.c \
	../src/gibbon-match-loader.c \
	../src/gibbon-match-reader.c \
	../src/gibbon-match-tracker.c \
	../src/gibbon-match-writer.c \
	../src/gibbon-move.c \
	../src/gibbon-move-list-view.c \
	../src/gibbon-movement.c \
	../src/gibbon-player-list.c \
	../src/gibbon-player-list-view.c \
	../src/gibbon-position.c \
	../src/gibbon-register-dialog.c \
	../src/gibbon-reject.c \
	../src/gibbon-reliability.c \
	../src/gibbon-reliability-renderer.c \
	../src/gibbon-resign.c \
	../src/gibbon-roll.c \
	../src/gibbon-saved-info.c \
	../src/gibbon-server-console.c \
	../src/gibbon-session.c \
	../src/gibbon-settings.c \
	../src/gibbon-sgf-reader.c \
	../src/gibbon-sgf-writer.c \
	../src/gibbon-shouts.c \
	../src/gibbon-signal.c \
	../src/gibbon-take.c \
	../src/gibbon-util.c \
	../src/html-entities.c \
	../src/svg-util.c

CATALOGS=$(shell LINGUAS="$(USE_LINGUAS)"; for lang in $$LINGUAS; do printf "$$lang.gmo "; done)

.SUFFIXES:
.SUFFIXES: .po .pox .gmo .mo .msg .cat

AM_DEFAULT_VERBOSITY = 0
INTLTOOL_V_MSGFMT = $(INTLTOOL__v_MSGFMT_$(V))
INTLTOOL__v_MSGFMT_= $(INTLTOOL__v_MSGFMT_$(AM_DEFAULT_VERBOSITY))
INTLTOOL__v_MSGFMT_0 = @echo "  MSGFMT" $@;

.po.pox:
	$(MAKE) $(GETTEXT_PACKAGE).pot
	$(MSGMERGE) $* $(GETTEXT_PACKAGE).pot -o $*.pox

.po.mo:
	$(INTLTOOL_V_MSGFMT)$(MSGFMT) -o $@ $<

.po.gmo:
	$(INTLTOOL_V_MSGFMT)file=`echo $* | sed 's,.*/,,'`.gmo \
	  && rm -f $$file && $(GMSGFMT) -o $$file $<

.po.cat:
	sed -f ../intl/po2msg.sed < $< > $*.msg \
	  && rm -f $@ && gencat $@ $*.msg


all: all-yes

all-yes: $(CATALOGS)
all-no:

$(GETTEXT_PACKAGE).pot: $(POTFILES)
	$(GENPOT)

install: install-data
install-data: install-data-yes
install-data-no: all
install-data-yes: all
	linguas="$(USE_LINGUAS)"; \
	for lang in $$linguas; do \
	  dir=$(DESTDIR)$(localedir)/$$lang/LC_MESSAGES; \
	  $(mkdir_p) $$dir; \
	  if test -r $$lang.gmo; then \
	    $(INSTALL_DATA) $$lang.gmo $$dir/$(GETTEXT_PACKAGE).mo; \
	    echo "installing $$lang.gmo as $$dir/$(GETTEXT_PACKAGE).mo"; \
	  else \
	    $(INSTALL_DATA) $(srcdir)/$$lang.gmo $$dir/$(GETTEXT_PACKAGE).mo; \
	    echo "installing $(srcdir)/$$lang.gmo as" \
		 "$$dir/$(GETTEXT_PACKAGE).mo"; \
	  fi; \
	  if test -r $$lang.gmo.m; then \
	    $(INSTALL_DATA) $$lang.gmo.m $$dir/$(GETTEXT_PACKAGE).mo.m; \
	    echo "installing $$lang.gmo.m as $$dir/$(GETTEXT_PACKAGE).mo.m"; \
	  else \
	    if test -r $(srcdir)/$$lang.gmo.m ; then \
	      $(INSTALL_DATA) $(srcdir)/$$lang.gmo.m \
		$$dir/$(GETTEXT_PACKAGE).mo.m; \
	      echo "installing $(srcdir)/$$lang.gmo.m as" \
		   "$$dir/$(GETTEXT_PACKAGE).mo.m"; \
	    else \
	      true; \
	    fi; \
	  fi; \
	done

# Empty stubs to satisfy archaic automake needs
dvi info ctags tags CTAGS TAGS ID:

# Define this as empty until I found a useful application.
install-exec installcheck:

uninstall:
	linguas="$(USE_LINGUAS)"; \
	for lang in $$linguas; do \
	  rm -f $(DESTDIR)$(localedir)/$$lang/LC_MESSAGES/$(GETTEXT_PACKAGE).mo; \
	  rm -f $(DESTDIR)$(localedir)/$$lang/LC_MESSAGES/$(GETTEXT_PACKAGE).mo.m; \
	done

check: all $(GETTEXT_PACKAGE).pot
	rm -f missing notexist
	srcdir=$(srcdir) $(INTLTOOL_UPDATE) -m
	if [ -r missing -o -r notexist ]; then \
	  exit 1; \
	fi

mostlyclean:
	rm -f *.pox $(GETTEXT_PACKAGE).pot *.old.po cat-id-tbl.tmp
	rm -f .intltool-merge-cache

clean: mostlyclean

distclean: clean
	rm -f Makefile Makefile.in POTFILES stamp-it
	rm -f *.mo *.msg *.cat *.cat.m *.gmo

maintainer-clean: distclean
	@echo "This command is intended for maintainers to use;"
	@echo "it deletes files that may require special tools to rebuild."
	rm -f Makefile.in.in

distdir = ../$(PACKAGE)-$(VERSION)/$(subdir)
dist distdir: $(DISTFILES)
	dists="$(DISTFILES)"; \
	extra_dists="$(EXTRA_DISTFILES)"; \
	for file in $$extra_dists; do \
	  test -f $(srcdir)/$$file && dists="$$dists $(srcdir)/$$file"; \
	done; \
	for file in $$dists; do \
	  test -f $$file || file="$(srcdir)/$$file"; \
	  ln $$file $(distdir) 2> /dev/null \
	    || cp -p $$file $(distdir); \
	done

update-po: Makefile
	$(MAKE) $(GETTEXT_PACKAGE).pot
	tmpdir=`pwd`; \
	linguas="$(USE_LINGUAS)"; \
	for lang in $$linguas; do \
	  echo "$$lang:"; \
	  result="`$(MSGMERGE) -o $$tmpdir/$$lang.new.po $$lang`"; \
	  if $$result; then \
	    if cmp $(srcdir)/$$lang.po $$tmpdir/$$lang.new.po >/dev/null 2>&1; then \
	      rm -f $$tmpdir/$$lang.new.po; \
            else \
	      if mv -f $$tmpdir/$$lang.new.po $$lang.po; then \
	        :; \
	      else \
	        echo "msgmerge for $$lang.po failed: cannot move $$tmpdir/$$lang.new.po to $$lang.po" 1>&2; \
	        rm -f $$tmpdir/$$lang.new.po; \
	        exit 1; \
	      fi; \
	    fi; \
	  else \
	    echo "msgmerge for $$lang.gmo failed!"; \
	    rm -f $$tmpdir/$$lang.new.po; \
	  fi; \
	done

Makefile POTFILES: stamp-it
	@if test ! -f $@; then \
	  rm -f stamp-it; \
	  $(MAKE) stamp-it; \
	fi

stamp-it: Makefile.in.in $(top_builddir)/config.status POTFILES.in
	cd $(top_builddir) \
	  && CONFIG_FILES=$(subdir)/Makefile.in CONFIG_HEADERS= CONFIG_LINKS= \
	       $(SHELL) ./config.status

# Tell versions [3.59,3.63) of GNU make not to export all variables.
# Otherwise a system limit (for SysV at least) may be exceeded.
.NOEXPORT:
