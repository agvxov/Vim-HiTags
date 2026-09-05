#!/usr/bin/env perl
use strict;
use warnings;
use feature 'signatures';
use File::Which;

# get-compiler-include-path.pl
#
# Prints the standard C++ header search path of the system's g++ or
# clang++ compiler, formatted as space-separated -I flags.
#
# Tries g++ first; falls back to clang++ if g++ is not on PATH.
# If neither compiler is available, exits silently with no output
# and no error.

sub get_include_search_paths($compiler) {
    my $output = qx(echo | $compiler -x c++ -E -v - 2>&1);

    return () unless defined $output && length $output;

    my @dirs;
    my $in_list = 0;

    for my $line (split /\n/, $output) {
        if ($line =~ /^#include <\.\.\.> search starts here:/) {
            $in_list = 1;
            next;
        }
        if ($line =~ /^End of search list\.?/) {
            last if $in_list;
            next;
        }
        if ($in_list) {
            my $dir = $line;
            $dir =~ s/^\s+|\s+$//g;
            push @dirs, $dir if length $dir;
        }
    }

    return @dirs;
}

sub path2I(@paths) {
    return map { "-I$_" } @paths;
}

my @candidates = ('g++', 'clang++');

my $compiler;
for my $c (@candidates) {
    if (which($c)) {
        $compiler = $c;
        last;
    }
}

exit 0 unless defined $compiler;

my @dirs = get_include_search_paths($compiler);

exit 0 unless @dirs;

print join(' ', path2I(@dirs)), "\n";

exit 0;
