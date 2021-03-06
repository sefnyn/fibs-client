#! /bin/perl -w
# This file is part of Gibbon.
# Gibbon is a Gtk+ frontend for the First Internet Backgammon Server FIBS.
# Copyright (C) 2009-2012 Guido Flohr, http://guido-flohr.net/.
#
# gibbon is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# gibbon is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with gibbon.  If not, see <http://www.gnu.org/licenses/>.

use strict;

# Configuration section.

# File names will be structured by a hyphen (foo-bar.h).  If you prefer
# the underscore, change it here:
my $filename_separator = '-';
#my $filename_separator = '_';

# By default, there is one space in front of the parentheses in
# function calls (resp. definitions).  Change it to the empty
# string if you prefer no space.
my $func_space = ' ';
#my $func_space = '';

# By default, there is one space in front of the parentheses in 
# macro calls.  Change it to the empty string if you prefer no space.
my $macro_space = ' ';
#my $macro_space = '';

# The copyright to use:
use constant GPL => '/*
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
 */';

use constant LGPL => '/*
 * This file is part of gibbon.
 * Gibbon is a Gtk+ frontend for the First Internet Backgammon Server FIBS.
 * Copyright (C) 2009-2012 Guido Flohr, http://guido-flohr.net/.
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 3 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with gibbon; if not, see <http://www.gnu.org/licenses/>.
 */';

use Getopt::Long;

sub class2file;
sub display_usage;
sub usage_error;

my $script_name = $0;
$script_name =~ s,.*/,,;
$script_name =~ s,.*\\,, if $^O =~/MSWin32/i;

my $use_gtk = $script_name =~ /^gtk/;

my $option_verbose;
my $option_help;
my $option_dry_run;
my $option_output_directory = '.';
my $option_library;
my $option_private;
my $option_parent;
my $option_widget;
my $option_gpl;
my $option_force;
my $option_quiet;

Getopt::Long::Configure ('bundling');
GetOptions (
        'o|output-directory=s' => \$option_output_directory,
        'f|force|overwrite' => \$option_force,

        'n|dry-run|just-print' => \$option_dry_run,

        'b|base-class|parent=s' => \$option_parent,
        'l|library=s' => \$option_library,
        'p|private' => \$option_private,
        'w|widget!' => \$option_widget,

        'g|gnu|gpl' => \$option_gpl,

        'q|quiet' => \$option_quiet,
        'v|verbose' => \$option_verbose,
        'h|help' => \$option_help,
) or usage_error;

display_usage if $option_help;

# Silently turn off verbose mode when doing a dry-run.
undef $option_verbose if $option_dry_run;

usage_error "The options '--verbose' and '--quiet' are mutually exclusive!\n"
        if ($option_verbose && $option_quiet);

unless (defined $option_parent && length $option_parent) {
        if ($option_widget) {
                $option_parent = 'GtkWidget';
        } else {
                $option_parent = 'GObject';
        }
}

my $class = shift @ARGV;
usage_error unless defined $class && length $class;

my $copyright = $option_gpl ? GPL : LGPL;

my $file_stem = class2file $class;
my $symbol_stem = $file_stem;
$symbol_stem =~ y/-/_/;
my $macro_stem = uc $symbol_stem;

my $header_prefix = '';
if (defined $option_library && length $option_library) {
    $header_prefix = 'LIB';
    $option_output_directory .= '/' . $option_library;
}

unless ($macro_stem =~ /^([A-Za-z][A-Za-z0-9]*)_(.+)$/) {
    die <<EOF;
$0: Your class name must contain an identifying prefix.  If your class
is for example "FooBar", then the prefix would be "Foo".
EOF
}
my ($macro_prefix, $macro_type) = ($1, $2);

my $parent_type = uc class2file $option_parent;
$parent_type =~ y/-/_/;
my $parent_symbol_stem = lc $parent_type;
my $parent_macro_stem = $parent_type;
unless ($parent_type =~ /^([A-Za-z][A-Za-z0-9]*)_(.+)$/) {
    die <<EOF;
$0: Your parent class name must contain an identifying prefix.  If it
is for example "FooBar", then the prefix would be "Foo".
EOF
}
$parent_type = "${1}_TYPE_$2";

# Fix for some well-known types:
if ('GtkVBox' eq $option_parent) {
        $parent_type = "GTK_TYPE_VBOX";
} elsif ('GtkHBox' eq $option_parent) {
        $parent_type = "GTK_TYPE_HBOX";
}

my $lib_header;

if ($option_library) {
        my $name = lc $macro_prefix . '.h';
        $lib_header = "<$option_library/$name>";
} else {
        $lib_header = qq{"$file_stem.h"};
}

my $macro_type_check = "${macro_prefix}_IS_$macro_type";
my $macro_class = "${macro_stem}_CLASS";

$macro_type = "${macro_prefix}_TYPE_$macro_type";

# Hide this from tools searching for this string.
my $fm = 'FIX' . 'ME';

my $destructor = $option_widget ? 'dispose' : 'finalize';

my $private_header = '';
my $private_implementation = '';
my $private_init = "\n";
my $private_finalize = '';
my $private_class_init = '';
my $private_new = '';
if ($option_private) {
        $private_header = <<EOF;


        /*< private >*/
        struct _${class}Private *priv;
EOF
        chop $private_header;

        $private_implementation = <<EOF;

typedef struct _${class}Private ${class}Private;
struct _${class}Private {
        /* $fm! Replace with the real structure of the private data! */
        gchar *dummy;
};

#define ${macro_stem}_PRIVATE(obj) (G_TYPE_INSTANCE_GET_PRIVATE$macro_space((obj), \\
        $macro_type, ${class}Private))
EOF

        $private_init = <<EOF;

        self->priv = G_TYPE_INSTANCE_GET_PRIVATE$macro_space(self,
                $macro_type, ${class}Private);

        /* $fm! Initialize private data! */
        self->priv->dummy = NULL;
EOF

        $private_finalize = <<EOF;

        $class *self = $macro_stem$macro_space(object);

        /* $fm! Free private data! */
        if (self->priv->dummy)
                g_free$func_space(self->priv->dummy);
        self->priv->dummy = NULL;
EOF

        $private_class_init = <<EOF;
        
        g_type_class_add_private$func_space(klass, sizeof$func_space(${class}Private));
EOF

        $private_new = <<EOF;

        /* $fm! Initialize private data! */
        /* self->priv->dummy = g_strdup$func_space(dummy); */
EOF
}

my $parent_class_init = '';
if ($option_parent ne 'GObject' && $option_parent ne 'GtkWidget') {
        $parent_class_init = <<EOF;
        ${option_parent}Class *${parent_symbol_stem}_class = ${parent_macro_stem}_CLASS$macro_space(klass);

        /* $fm! Initialize pointers to methods from parent class! */
        /* ${parent_symbol_stem}_class->do_this = ${symbol_stem}_do_this; */
EOF
}

print "cat >$option_output_directory/$file_stem.h <<EOF\n" if $option_dry_run;

unless ($option_dry_run) {
        die "$0: Output directory $option_output_directory does not exist!\n"
                unless -d $option_output_directory;
        my  $outfile = "$option_output_directory/$file_stem.h";
        die "$0: File '$outfile' exists! Won't override without --force.\n" 
                if -e $outfile && !$option_force;
        open HEADER, ">$outfile" or die "Cannot create '$outfile': $!\n";
} else {
        *HEADER = *STDOUT;
}

print "Writing C header file '$option_output_directory/$file_stem.h'.\n"
        if $option_verbose;
my $header_result = print HEADER <<EOF;
$copyright

#ifndef _$header_prefix${macro_stem}_H
# define _$header_prefix${macro_stem}_H

#ifdef HAVE_CONFIG_H
# include <config.h>
#endif

#include <glib.h>
#include <glib-object.h>

#define $macro_type \\
        (${symbol_stem}_get_type$func_space())
#define $macro_stem(obj) \\
        (G_TYPE_CHECK_INSTANCE_CAST$macro_space((obj), $macro_type, \\
                $class))
#define $macro_class(klass) (G_TYPE_CHECK_CLASS_CAST$macro_space((klass), \\
        $macro_type, ${class}Class))
#define $macro_type_check(obj) \\
        (G_TYPE_CHECK_INSTANCE_TYPE$macro_space((obj), \\
                $macro_type))
#define ${macro_type_check}_CLASS(klass) \\
        (G_TYPE_CHECK_CLASS_TYPE$macro_space((klass), \\
                $macro_type))
#define ${macro_stem}_GET_CLASS(obj) \\
        (G_TYPE_INSTANCE_GET_CLASS$macro_space((obj), \\
                $macro_type, ${class}Class))

/**
 * $class:
 *
 * One instance of a #$class.  All properties are private.
 */
typedef struct _$class $class;
struct _$class
{
        $option_parent parent_instance;$private_header
};

/**
 * ${class}Class:
 *
 * $fm! The author was negligent enough to not document this class!
 */
typedef struct _${class}Class ${class}Class;
struct _${class}Class
{
        /* <private >*/
        ${option_parent}Class parent_class;
};

GType ${symbol_stem}_get_type$func_space(void) G_GNUC_CONST;

$class *${symbol_stem}_new$func_space(/* $fm! Argument list! */ const gchar *dummy);

#endif
EOF

unless ($option_dry_run) {
        die "Error writing '$option_output_directory/$file_stem.h': $!\n"
                unless $header_result;
        close HEADER or
                die "Error closing '$option_output_directory/$file_stem.h': $!\n"
}

if ($option_dry_run) {
        print <<EOS;
EOF

cat >$option_output_directory/$file_stem.c <<EOF
EOS
}

unless ($option_dry_run) {
        my  $outfile = "$option_output_directory/$file_stem.c";
        die "$0: File '$outfile' exists! Won't override without --force.\n" 
                if -e $outfile && !$option_force;
        open CFILE, ">$outfile" or die "Cannot create '$outfile': $!\n";
} else {
        *CFILE = *STDOUT;
}

print "Writing C file '$option_output_directory/$file_stem.c'.\n"
        if (!$option_dry_run && $option_verbose);
my $cfile_result = print CFILE <<EOF;
$copyright

/**
 * SECTION:$file_stem
 * \@short_description: $fm! Short description missing!
 *
 * Since: 0.2.0
 *
 * $fm! Long description missing!
 */

#include <glib.h>
#include <glib/gi18n.h>

#include $lib_header
$private_implementation
G_DEFINE_TYPE$macro_space($class, $symbol_stem, $parent_type)

static void 
${symbol_stem}_init$func_space($class *self)
{$private_init}

static void
${symbol_stem}_$destructor$func_space(GObject *object)
{$private_finalize
        G_OBJECT_CLASS$macro_space(${symbol_stem}_parent_class)->$destructor(object);
}

static void
${symbol_stem}_class_init$func_space(${class}Class *klass)
{
        GObjectClass *object_class = G_OBJECT_CLASS$macro_space(klass);
$parent_class_init$private_class_init
        /* $fm! Initialize pointers to methods! */
        /* klass->do_that = ${class}_do_that; */

        object_class->$destructor = ${symbol_stem}_$destructor;
}

/**
 * ${symbol_stem}_new:
 * \@dummy: The argument.
 *
 * Creates a new #$class.
 *
 * Returns: The newly created #$class or %NULL in case of failure.
 */
$class *
${symbol_stem}_new$func_space(/* $fm! Argument list! */ const gchar *dummy)
{
        $class *self = g_object_new$func_space($macro_type, NULL);
$private_new
        return self;
}
EOF

unless ($option_dry_run) {
        die "Error writing '$option_output_directory/$file_stem.c': $!\n"

                unless $cfile_result;
        close CFILE or
                die "Error closing '$option_output_directory/$file_stem.c': $!\n"
}

my $sources_variable;
my $headers_variable;
my $sources_found;
my $headers_found;
my $sources_ready;
my $headers_ready;
if (-e "$option_output_directory/Makefile.am") {
        my $makefile_am = "$option_output_directory/Makefile.am";
        print "Trying to patch $makefile_am.\n" if $option_verbose;

        local *MAKEFILE_AM;
        open MAKEFILE_AM, "<$makefile_am"
                or die "Cannot open '$makefile_am' for reading: $!\n";
        my $in_sources;
        my $in_headers;
        my $output = '';

        while (my $line = <MAKEFILE_AM>) {
                last unless defined $line;
                if ($in_sources) {
                        my $qf = quotemeta "$file_stem.c";
                        if ($line =~  /(?:\A|=|[ \t]+)$qf(?:\Z|\\|[ \t]+)/) {
                                undef $in_sources;
                                $sources_ready = 1;
                        } elsif ($line !~ /\\\n$/) {
                                chomp $line;
                                $line .= "\t\t\t\\\n\t$file_stem.c\t\n";
                                undef $in_sources;
                                $sources_found = 1;
                        }
                } elsif ($in_headers) {
                        my $qf = quotemeta "$file_stem.h";
                        if ($line =~  /(?:\A|=|[ \t]+)$qf(?:\Z|\\|[ \t]+)/) {
                                undef $in_headers;
                                $headers_ready = 1;
                        } elsif ($line !~ /\\\n$/) {
                                chomp $line;
                                $line .= "\t\t\t\\\n\t$file_stem.h\n";
                                undef $in_headers;
                                $headers_found = 1;
                        }
                } else {
                        if (!$sources_found && !$sources_ready) {
                                if ($line =~ /^([_a-zA-Z][_a-zA-Z0-9]*_SOURCES)[ \t]*=/) {
                                        $in_sources = 1;
                                        $sources_variable = $1;
                                        redo;
                                }
                        } elsif (!$headers_found && !$headers_ready) {
                                if ($line =~ /^([_a-zA-Z][_a-zA-Z0-9]*_HEADERS)[ \t]*=/) {
                                        $in_headers = 1;
                                        $headers_variable = $1;
                                        redo;
                                }
                        }
                }
                $output .= $line;
        }

        unless ($option_quiet) {
                warn "No _SOURCES variable found in '$makefile_am'.\n"
                        unless $sources_found || $sources_ready;
                warn "No _HEADERS variable found in '$makefile_am'.\n"
                        unless $headers_found || $headers_ready;
        }
        if ($sources_found || $headers_found) {
                if ($option_dry_run) {
                        print "cat >$makefile_am <<EOF\n";
                } elsif ($option_verbose) {
                        print "Patching $makefile_am.\n";
                }

                unless ($option_dry_run) {
                        open MAKEFILE_AM, ">$makefile_am"
                                or die "Cannot overwrite '$makefile_am': $!\n";
                } else {
                        *MAKEFILE_AM = *STDOUT;
                }

                my $result = print MAKEFILE_AM $output;

                unless ($option_dry_run) {
                        die ("Error writing"
                             . " '$option_output_directory/$file_stem.c': $!\n")

                                unless $cfile_result;
                        close MAKEFILE_AM or
                                die ("Error closing"
                                     . "'$option_output_directory"
                                     . "/$file_stem.c': $!\n");
                }
        }
} elsif (!$option_quiet) {
        warn "$0: '$option_output_directory/Makefile.am' not found!\n";
}

if ($option_dry_run) {
        my $private = $option_private ? 'a' : 'no';
        my $sources_line;
        if ($sources_found) {
                $sources_line = "C source file"
                                . " '$option_output_directory/$file_stem.c" 
                                . " will be added to"
                                . " variable\n"
                                . "#     $sources_variable in automake file"
                                . " '$option_output_directory/Makefile.am'.";
        } elsif ($sources_ready) {
                $sources_line = "C source file"
                                . " '$option_output_directory/$file_stem.c" 
                                . " was already added to"
                                . " variable\n"
                                . "#     $sources_variable in automake file"
                                . " '$option_output_directory/Makefile.am'.";
        } else {
                $sources_line = "No _SOURCES variable found in"
                                . " '$option_output_directory/Makefile.am'.";
        }

        my $headers_line;
        if ($headers_found) {
                $headers_line = "C header file"
                                . " '$option_output_directory/$file_stem.h" 
                                . " will be added to"
                                . " variable\n"
                                . "#     $headers_variable in automake file"
                                . " '$option_output_directory/Makefile.am'.";
        } elsif ($headers_ready) {
                $headers_line = "C header file"
                                . " '$option_output_directory/$file_stem.h" 
                                . " was already added to"
                                . " variable\n"
                                . "#     $headers_variable in automake file"
                                . " '$option_output_directory/Makefile.am'.";
        } else {
                $headers_line = "No _HEADERS variable found in"
                                . " '$option_output_directory/Makefile.am'.";
        }

        print <<EOS;

EOF

# Your class is called $class.
# The header file for it is '$option_output_directory/$file_stem.h'.
# The C implementation is in '$option_output_directory/$file_stem.c'.
# The GLib type macro for $class is $macro_type.
# The GLib type macro for the parent class $option_parent is $parent_type.
# Instances of $class contain $private private data structure.
# $sources_line
# $headers_line
EOS
}

sub class2file {
	my ($name) = @_;

	$name =~ s/[A-Z][a-z]+/$&$filename_separator/g;
	chop $name;
	$name =~ s/[A-Z]+(?=[A-Z])/$&$filename_separator/g;

	return lc $name;
}

sub display_usage {
    my $default_is_widget = $use_gtk ? 'yes' : 'no';
    my $default_no_widget = $use_gtk ? 'no' : 'yes';

    print <<EOF;
Usage: $0 [OPTIONS] CLASS

Create a GLib class skeleton.

Options mandatory to short options are mandatory to long options, too!

  -o, --output-directory             Guess what! Defaults to '.'.
  -f, --force, --overwrite           Overwrite existing files.
  -n, --dry-run, --just-print        Do not create files but display them
                                     on standard output as a shell script.
                                     At the end of outpu you will find an 
                                     informative comment.

  -b, --base-class, --parent=PARENT  Derive class from PARENT class.
  -l, --library=LIBRARY              Assume class to be part of LIBRARY.
                                     Among other, ./LIBRARY is automatically
                                     appended to the output directory.
  -p, --private                      Insert private structure.
  -w, --widget                       Default base class is GtkWidget (defaults
                                     to $default_is_widget)
      --nowidget                     Default base class is GObject (defaults
                                     to $default_no_widget)

  -g, --gnu, --gpl                   Use GNU General Public License version 3
                                     (default is the GNU Lesser General
                                     Public License version 3)

  -q, --quiet                        Only display fatal errors.
  -v, --verbose                      Print what is done.
  -h, --help                         Display this help and exit.

The script creates the C header file (.h) and implementation (.c)
file for a GLib class.

Example:

  $0 --library=libfoomatic --private FoomaticXMLPrinter

This would create the files ./libfoomatic/foomatic-xml-printer.h and
./libfoomatic/foomatic-xml-printer.c.  The stem for preprocessor macros
would be FOOMATIC_XML_PRINTER.  All symbols would start with
foomatic_xml_printer.  Object instances of FoomaticXMLPrinter would
contain a private data structure.

If a Makefile.am is found in the output directory, the script will
try to patch it.  The C file will be added to the first variable
with a name ending in _SOURCES.  The C header file will be added to
the first variable ending in _HEADERS.  If either of them fails,
a warning will be printed unless the option '--quiet' was given.

Use the --dry-run option until you get an idea of what the different
options will do.  If that is not enough, then edit the configuration file
for this program.  It is called '$0'. ;-)
EOF

    exit 0;
}

sub usage_error {
    my $message = shift;
    if ($message) {
        $message =~ s/\s+$//;
        $message = "$0: $message\n";
    } else {
        $message = '';
    }
    die <<EOF;
${message}Usage: $0 [OPTIONS] CLASS
Try '$0 --help' for more information!
EOF
}

