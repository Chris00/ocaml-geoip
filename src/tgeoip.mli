type context
type result = {
  country_code : string;
  country_code3 : string;
  country_name : string;
  city : string;
  latitude : float;
  longitude : float;
  region : string;
}
external create_context : string -> context = "ocaml_create_context"
external by_addr : context -> string -> result = "ocaml_GeoIP_record_by_addr"

