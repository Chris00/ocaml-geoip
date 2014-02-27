open OUnit2
open Tgeoip

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
          let ctx = Tgeoip.create_context db in
          let ips = (gen 1000)  in
          let locations =
            List.map (fun ip ->
              try
                let result = Tgeoip.by_addr ctx ip in
                (ip, (result.longitude, result.latitude))
              with _ -> (ip, (0.00, 0.00))) ips in
          assert_equal (List.length locations > 0) true
        )
    ]

let suite = "Unit tests" >::: [ unit_test "data/GeoIPCity.dat" ]

let _ =
  run_test_tt_main suite
