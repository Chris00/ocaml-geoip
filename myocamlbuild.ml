(* OASIS_START *)
(* OASIS_STOP *)

open Ocamlbuild_plugin
open Command

(* Generic pkg-config(1) support. *)

let os = Ocamlbuild_pack.My_unix.run_and_read "uname -s"

let pkg_config flags package =
  let cmd tmp =
    Command.execute ~quiet:true &
    Cmd( S [ A "pkg-config"; A ("--" ^ flags); A package; Sh ">"; A tmp]);
    List.map (fun arg -> A arg) (string_list_of_file tmp)
  in
  with_temp_file "pkgconfig" "pkg-config" cmd

let pkg_config_lib ~lib ~has_lib ~stublib =
  let cflags = (A has_lib) :: pkg_config "cflags" lib in
  let stub_l = [A (Printf.sprintf "-l%s" stublib)] in
  let libs_l = pkg_config "libs-only-l" lib in
  let libs_L = pkg_config "libs-only-L" lib in
  let linker = match os with
  | "Linux\n" -> [A "-Wl,-no-as-needed"]
  | _ -> []
  in
  let make_opt o arg = S [ A o; arg ] in
  let mklib_flags = (List.map (make_opt "-ldopt") linker) @ libs_l @ libs_L in
  let compile_flags = List.map (make_opt "-ccopt") cflags in
  let lib_flags = List.map (make_opt "-cclib") libs_l in
  let link_flags = List.map (make_opt "-ccopt") (linker @ libs_L) in
  let stublib_flags = List.map (make_opt "-dllib") stub_l  in

  flag ["c"; "ocamlmklib"] (S mklib_flags);
  flag ["c"; "compile"] (S compile_flags);
  flag ["link"; "ocaml"] (S (link_flags @ lib_flags));
  flag ["link"; "ocaml"; "library"; "byte"] (S stublib_flags)

let () =
  let dispatch_pkg_config = function
    | After_rules ->
       pkg_config_lib ~lib:"geoip" ~has_lib:"-DHAS_GEOIP"
                      ~stublib:"tgeoip_stubs"
    | _ -> ()
  in
  dispatch (MyOCamlbuildBase.dispatch_combine
              [dispatch_pkg_config; dispatch_default])
