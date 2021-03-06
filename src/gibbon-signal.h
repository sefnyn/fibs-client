/*
 * This file is part of gibbon.
 * Gibbon is a Gtk+ frontend for the First Internet Backgammon Server FIBS.
 * Copyright (C) 2009-2012 Guido Flohr, http://guido-flohr.net/.
 *
 * gibbon is free software: you can redistribute it and/or modify 
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * gibbon is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with gibbon.  If not, see <http://www.gnu.org/licenses/>.
 */

#ifndef _GIBBON_SIGNAL_H
# define _GIBBON_SIGNAL_H

#include <glib.h>
#include <glib-object.h>

#define GIBBON_TYPE_SIGNAL \
        (gibbon_signal_get_type ())
#define GIBBON_SIGNAL(obj) \
        (G_TYPE_CHECK_INSTANCE_CAST ((obj), GIBBON_TYPE_SIGNAL, \
                GibbonSignal))
#define GIBBON_SIGNAL_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), \
        GIBBON_TYPE_SIGNAL, GibbonSignalClass))
#define GIBBON_IS_SIGNAL(obj) \
        (G_TYPE_CHECK_INSTANCE_TYPE ((obj), \
                GIBBON_TYPE_SIGNAL))
#define GIBBON_IS_SIGNAL_CLASS(klass) \
        (G_TYPE_CHECK_CLASS_TYPE ((klass), \
                GIBBON_TYPE_SIGNAL))
#define GIBBON_SIGNAL_GET_CLASS(obj) \
        (G_TYPE_INSTANCE_GET_CLASS ((obj), \
                GIBBON_TYPE_SIGNAL, GibbonSignalClass))

/**
 * GibbonSignal:
 *
 * One instance of a #GibbonSignal.  All properties are private.
 **/
typedef struct _GibbonSignal GibbonSignal;
struct _GibbonSignal
{
        GObject parent_instance;

        /*< private >*/
        struct _GibbonSignalPrivate *priv;
};

/**
 * GibbonSignalClass:
 *
 * Wrapper class for a glib signal bound to an object!
 **/
typedef struct _GibbonSignalClass GibbonSignalClass;
struct _GibbonSignalClass
{
        /* <private >*/
        GObjectClass parent_class;
};

GType gibbon_signal_get_type (void) G_GNUC_CONST;

GibbonSignal *gibbon_signal_new (GObject *emitter, const gchar *name,
                                 GCallback callback, GObject *receiver);

#endif
