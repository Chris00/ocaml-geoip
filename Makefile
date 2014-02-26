


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

#
# Builds a .cma file. Not sure how to use it in an UTOP thing yet.
#
build:
	 ocamlbuild -use-ocamlfind -pkgs ounit src/tgeoip.cma

# See this for more information.
#
# https://github.com/ocamllabs/ocaml-ctypes/issues/51#issuecomment-30729675
#
