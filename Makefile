NAME = $(shell oasis query name)
DIR = $(NAME)-$(shell oasis query version)
TARBALL = $(DIR).tar.gz

DISTFILES = AUTHORS.txt INSTALL.txt README.txt \
  Makefile myocamlbuild.ml _oasis _tags \
  $(wildcard $(addprefix src/,*.ml *.mli *.clib *.mllib *.c *.h))

all byte native setup.log: setup.data
	ocaml setup.ml -build

configure: setup.data
setup.data: setup.ml
	ocaml setup.ml -configure --enable-tests

setup.ml: _oasis
	oasis setup -setup-update dynamic

doc install uninstall reinstall: setup.log
	ocaml setup.ml -$@

test: byte
	LD_LIBRARY_PATH=_build/src/ ./unittests.byte

.PHONY: configure all byte native doc install uninstall reinstall test

.PHONY: dist tar
dist tar: setup.ml
	mkdir -p $(DIR)
	for f in $(DISTFILES); do \
	  cp -r --parents $$f $(DIR); \
	done
# Make a setup.ml independent of oasis:
	cd $(DIR) && oasis setup
	tar -zcvf $(TARBALL) $(DIR)
	$(RM) -r $(DIR)

.PHONY: clean distclean
clean: setup.ml
	ocaml setup.ml -clean
	$(RM) $(TARBALL) iterate.dat

distclean: setup.ml
	ocaml setup.ml -distclean
	$(RM) $(wildcard *.ba[0-9] *.bak *~ *.odocl)
