let sprintf = Printf.sprintf

let test_degs_to_rads () = 
    Alcotest.(check (float 0.0001)) "Check degs_to_rads" 0.0174533 (H3.degs_to_rads 1.0)

let test_rads_to_degs () = 
    Alcotest.(check (float 0.0001)) "Check rads_to_degs" 57.2958 (H3.rads_to_degs 1.0)

let test_is_valid () =
    let h3 = H3.string_to_h3 "845ad1bffffffff" in
    Alcotest.(check int) "check is_valid" 1 (H3.h3_is_valid h3)

let test_d2r_r2d_roundtrip () = 
    let result = H3.degs_to_rads 40.7128 |> H3.rads_to_degs in
    Alcotest.(check (float 0.0001)) "check d2r_r2d roundtrip" 40.7128 result

let test_r2d_d2r_roundtrip () = 
    let result = (H3.rads_to_degs 0.7105724077 |> H3.degs_to_rads) in
    Alcotest.(check (float 0.0001)) "Check test_r2d_d2r_roundtrip" 0.7105724077 result

let test_max_kring_size () = 
    Alcotest.(check bool) "check max_kring_size" true ((H3.max_kring_size 3) > 0)

(* From the Examples: https://uber.github.io/h3/#/documentation/core-library/unix-style-filters
echo 40.689167 -74.044444 | geoToH3 5
852a1073fffffff
*)
let test_geo_to_h3 () =
    let _result = H3.geo_to_h3 (H3.degs_to_rads 40.689167) (H3.degs_to_rads (-74.044444)) 5 in
    let result = sprintf "%Lx" _result in
     Alcotest.(check string) "Check string H3" "852a1073fffffff" result
(*
echo 845ad1bffffffff | h3ToGeo
22.3204847179 169.7200239903
*)
let test_h3_to_geo () = 
    (*
    ((lat -. 22.3204847179) < 0.0001) && ((lon -. 169.7200239903) < 0.0001)
    *)
    let x = Scanf.sscanf "845ad1bffffffff" "%Lx" (fun s -> s) in
    let lat, lon = H3.h3_to_geo x in
    let lat, lon = H3.rads_to_degs lat, H3.rads_to_degs lon in
    Alcotest.(check (float 0.0001)) "check h3_to_geo lat" 22.3204847179 lat;
    Alcotest.(check (float 0.0001)) "check h3_to_geo lon" 169.7200239903 lon

let test_hex_area_km2_decreasing () =
    let h3_resolutions = [15; 14; 13; 12; 11; 10; 9; 8; 7; 6; 5; 4; 3; 2; 1] in
    let _results = List.map (fun i -> (H3.hex_area_km2 i) < (H3.hex_area_km2 (i-1))) h3_resolutions in
    let result = List.fold_left (fun acc x -> acc = x) true _results in
    Alcotest.(check bool) "Check test hex area decreasing" true result

let test_self_not_a_neighbor () =
    let sf_h3 = H3.geo_to_h3 0.659966917655 (-2.1364398519396) 9 in
    let result = H3.h3_indexes_are_neighbors sf_h3 sf_h3 in
    Alcotest.(check int) "Check self not a neighbor" 0 result

let test_set = [
    "test_degs_to_rads", `Slow, test_degs_to_rads;
    "test_rads_to_degs", `Slow, test_rads_to_degs;
    "test_is_valid", `Slow, test_is_valid;
    "test_d2r_r2d_roundtrip", `Slow, test_d2r_r2d_roundtrip;
    "test_r2d_d2r_roundtrip", `Slow, test_r2d_d2r_roundtrip;
    "test_max_kring_size", `Slow, test_max_kring_size;
    "test_geo_to_h3", `Slow, test_geo_to_h3;
    "test_h3_to_geo", `Slow, test_h3_to_geo;
    "test_hex_area_km2_decreasing", `Slow, test_hex_area_km2_decreasing;
    "test_self_not_a_neighbor", `Slow, test_self_not_a_neighbor;
]

let () =
    Alcotest.run "Run Tests" [
        "test_1", test_set;
    ]
