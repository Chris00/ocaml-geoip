
pkg:
	ocamlbuild -use-ocamlfind tgeoip.{mli,cmi,cmx,cma,a,cmxa,cmxs} dlltgeoip.so META

install:
	ocamlfind install tgeoip META _build/src/tgeoip.{mli,cmi,cmx,cma,a,cmxa,cmxs} _build/src/dlltgeoip.so

test:
	ocamlbuild -use-ocamlfind -package ounit -package tgeoip  src/unittests.byte
	ocamlrun ./_build/src/unittests.byte
