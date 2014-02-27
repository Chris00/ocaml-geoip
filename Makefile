


# After having run this target you should be able to run:
#
#     ./myutop -I _build/src/
#     #load "tgeoip.cmo";;
#     Tgeoip.create_context;;
#
# And get the type signature of create_context without any error
# 'Error: The external function `ocaml_GeoIP_record_by_addr' is not
# available'
custom_top:
	ocamlbuild src/tgeoip_stubs.o
	ocamlbuild -pkgs ounit src/tgeoip.cma
	ocamlmktop -custom -cclib -lGeoIp _build/src/tgeoip_stubs.o _build/src/tgeoip.cma -o myutop

pkg:
	ocamlbuild -use-ocamlfind -package ounit tgeoip.{mli,cmi,cmx,cma,a,cmxa,cmxs} dlltgeoip.so META

install:
	ocamlfind install tgeoip META _build/src/tgeoip.{mli,cmi,cmx,cma,a,cmxa,cmxs} _build/src/dlltgeoip.so
