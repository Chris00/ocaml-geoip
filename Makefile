


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

build:
	ocamlbuild -use-ocamlfind -pkgs ounit src/tgeoip.cma

#
# I can easily build the .cma using
#
#    ocamlbuild -use-ocamlfind -pkgs ounit src/tgeoip.cma
#
# But I can't figure out how to install it.
#
# I can run:
#
#     ocamlfind install tgeoip META
#
# But that just places the MEATA file somewhere
