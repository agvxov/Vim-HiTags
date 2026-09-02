#!/usr/bin/perl
use strict;
use warnings;
use feature 'signatures';

sub usage {
    print "tags-from-header.pl <file>+   : generate tags file for each file\n";
    exit 1;
}

sub strip_ext($file) {
    (my $base = $file) =~ s/\.[^.\/]+$//;
    return $base;
}

sub header_name2tags_name($file) {
    return strip_ext($file) . ".tags";
}

sub header_name2processed_name($file) {
    return strip_ext($file) . ".i";
}

sub preprocess($file) {
    my $preprocessor = "gcc -E -D_GNU_SOURCE";
    my $out = header_name2processed_name($file);
    system("$preprocessor \Q$file\E > \Q$out\E") == 0
        or die "preprocess failed for '$file': $?";
    return $out;
}

sub tag($orig_file, $processed_file) {
    my $out = header_name2tags_name($orig_file);
    system(
        'ctags',
        '--extras=+F',
        '--language-force=C++',
        '--kinds-C++=+px',
        '-f', $out,
        $processed_file
    ) == 0 or die "ctags failed for '$orig_file': $?";
    return $out;
}

sub tags_from_header($file) {
    print "Starting to process $file...";
    my $processed_header = preprocess($file);
    tag($file, $processed_header);
    unlink($processed_header);
    print "Done.\n";
}

usage() unless @ARGV;

for my $file (@ARGV) {
    tags_from_header($file);
}
