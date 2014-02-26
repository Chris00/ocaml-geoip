(* Simple geolocalisation module *)

type context

type result =
    {
      country_code : string ;
      country_code3 : string ;
      country_name : string ;
      city : string ;
      latitude : float ;
      longitude : float ;
      region : string ;
    }

external create_context : string -> context = "ocaml_create_context"
external by_addr : context -> string -> result = "ocaml_GeoIP_record_by_addr"

module Test = struct
  open OUnit2

  let unit_test db = "geolocalisation" >:::
    [
      "test_on_random_ip" >::
        (fun _ ->
          let random_ip () =
            Printf.sprintf "%d.%d.%d.%d" (1 + Random.int 254) (1 + Random.int 254) (1 + Random.int 254) (1 + Random.int 254)
          in
          let rec gen = function
            | 0 -> []
            | n -> random_ip () :: (gen (n-1))
          in
          let ctx = create_context db in
          let ips = (gen 1000)  in
          let locations =
            List.map (fun ip ->
              try
                let result = by_addr ctx ip in
                (ip, (result.longitude, result.latitude))
              with _ -> (ip, (0.00, 0.00))) ips in
          assert_equal (List.length locations > 0) true
        )
    ]
end
let unit_test = Test.unit_test
