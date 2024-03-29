#TARGET.featch = $$(find '/var/db/repos/gentoo/sys-devel/gcc/' -iname '*.ebuild' ! -regex '.*\.9999\.eobject' | head -1)
#TARGET.untar = $$(find ./ -iname '*.tar.*' ! -regex '.*patch.*' ! -regex '.*lockfile.*' | head -1)
#
#CTAGS.flags := --recurse --extras=+F #--output-format=json
#
#tags: clean cxxtags
#	ctags_to_vim_hi.py -i object/cxx.tags
#
#cxxtags:
#	gcc -E builder/include_std.c > object/include_std.i
#	ctags ${CTAGS.flags} --language-force=C -o object/cxx.tags object/include_std.i
#
#clean: clean_object_source clean_cxx
#	-rm object/*.tags
#
#clean_cxx:
#	-rm -frfr object/include_std.i
#	-rm -frfr object/cxx.tags
#
#clean_object_source:
#	-rm -frfr object/gcc-*
#
#update_object_source: clean_object_source
#	cd object/;                       \
#	export DISTDIR="$$(realpath .)"; \
#	eobject ${TARGET.featch} fetch
#	cd object/;           \
#	tar -x -f ${TARGET.untar}

bundle: clean
	-mkdir object/.vim/
	-mkdir object/.vim/plugin/
	cp hitags.vim object/.vim/plugin/
	-mkdir object/.vim/plugin/HiTags/
	cp hitags.py object/.vim/plugin/HiTags/
	tar -C object/ -c .vim/ -f hitags.tar

install: bundle
	tar -x -f hitags.tar --dereference -C ~/

clean:
	-rm -frfr object/*
	-rm -frfr object/.vim/
	-rm -frfr hitags.tar
