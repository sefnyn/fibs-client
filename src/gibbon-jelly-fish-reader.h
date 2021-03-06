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

#ifndef _GIBBON_JELLY_FISH_READER_H
# define _GIBBON_JELLY_FISH_READER_H

#ifdef HAVE_CONFIG_H
# include <config.h>
#endif

#include <glib.h>
#include <glib-object.h>

#include "gibbon-match-reader.h"

#define GIBBON_TYPE_JELLY_FISH_READER \
        (gibbon_jelly_fish_reader_get_type ())
#define GIBBON_JELLY_FISH_READER(obj) \
        (G_TYPE_CHECK_INSTANCE_CAST ((obj), GIBBON_TYPE_JELLY_FISH_READER, \
                GibbonJellyFishReader))
#define GIBBON_JELLY_FISH_READER_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), \
        GIBBON_TYPE_JELLY_FISH_READER, GibbonJellyFishReaderClass))
#define GIBBON_IS_JELLY_FISH_READER(obj) \
        (G_TYPE_CHECK_INSTANCE_TYPE ((obj), \
                GIBBON_TYPE_JELLY_FISH_READER))
#define GIBBON_IS_JELLY_FISH_READER_CLASS(klass) \
        (G_TYPE_CHECK_CLASS_TYPE ((klass), \
                GIBBON_TYPE_JELLY_FISH_READER))
#define GIBBON_JELLY_FISH_READER_GET_CLASS(obj) \
        (G_TYPE_INSTANCE_GET_CLASS ((obj), \
                GIBBON_TYPE_JELLY_FISH_READER, GibbonJellyFishReaderClass))

/**
 * GibbonJellyFishReader:
 *
 * One instance of a #GibbonJellyFishReader.  All properties are private.
 */
typedef struct _GibbonJellyFishReader GibbonJellyFishReader;
struct _GibbonJellyFishReader
{
        GibbonMatchReader parent_instance;

        /*< private >*/
        struct _GibbonJellyFishReaderPrivate *priv;
};

/**
 * GibbonJellyFishReaderClass:
 *
 * Reader for the JellyFish format.
 */
typedef struct _GibbonJellyFishReaderClass GibbonJellyFishReaderClass;
struct _GibbonJellyFishReaderClass
{
        /* <private >*/
        GibbonMatchReaderClass parent_class;
};

GType gibbon_jelly_fish_reader_get_type (void) G_GNUC_CONST;

GibbonJellyFishReader *gibbon_jelly_fish_reader_new (
                GibbonMatchReaderErrorFunc error_func,
                gpointer user_data);

#endif
