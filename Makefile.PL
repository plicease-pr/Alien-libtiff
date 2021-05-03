use strict;
use warnings;
use ExtUtils::MakeMaker;
use Alien::Build::MM;
use English;

my %WriteMakefileArgs = (
    "ABSTRACT"           => "Find or build libtiff",
    "AUTHOR"             => "Jeffrey Ratcliffe <ratcliffe\@cpan.org>",
    "VERSION_FROM"       => "lib/Alien/libtiff.pm",
    "CONFIGURE_REQUIRES" => {
        "ExtUtils::MakeMaker" => "6.52",
    },
    "PREREQ_PM" => {
        "Alien::Base"    => "0.038",
        "PkgConfig"      => 0,
        "Sort::Versions" => 0,
    },
    "DISTNAME" => "Alien-libtiff",
    "LICENSE"  => "perl",
    "NAME"     => "Alien::libtiff",
);

my $abmm = Alien::Build::MM->new;
%WriteMakefileArgs = $abmm->mm_args(%WriteMakefileArgs);

WriteMakefile(%WriteMakefileArgs);

sub MY::postamble {

    # GNU Make extensions that BSD make doesn't like.
    # Author-only stuff, so comment out for non-Linux.
    my $postamble = '';
    if ( $OSNAME eq 'linux' ) {
        $postamble = <<'END';
SHELL = bash
MANIFEST = $(shell cat MANIFEST)
SOURCE = $(filter bin/% examples/% %.pm %.PL %.pl %.t,$(MANIFEST))
SOURCE_TIDY = $(foreach file,$(SOURCE),$(file).tdy)

MANIFEST : $(SOURCE)
	git ls-files | egrep -v '^\.(git|be)' > $@

tardist : README

README : lib/Graphics/TIFF.pm
	pod2readme $< $@

tidy : MANIFEST $(SOURCE_TIDY)

%.tdy : %
	perltidy $* && if ! diff -q $@ $* > /dev/null; then cp $@ $*; fi
END
    }
    return $postamble . $abmm->mm_postamble;
}
