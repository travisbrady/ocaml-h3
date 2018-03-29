let sprintf = Printf.sprintf

type h3_index = int64
type geo_coord = {lat: float; lon: float}
type geo_boundary = {num_verts: int; verts: geo_coord array}

external degs_to_rads : float -> float = "caml_degsToRads"
external rads_to_degs : float -> float = "caml_radsToDegs"
external geo_to_h3 : float -> float -> int -> h3_index = "caml_geoToH3"
external h3_to_geo : h3_index -> float * float = "caml_h3ToGeo"
external h3_to_geo_boundary : h3_index -> geo_boundary = "caml_h3ToGeoBoundary"
external max_kring_size : int -> int = "caml_maxKringSize"
external k_ring : h3_index -> int -> h3_index array = "caml_kRing"
external k_ring_distances : h3_index -> int -> h3_index array * int array = "caml_kRingDistances"
external hex_range : h3_index -> int -> h3_index = "caml_hexRange"
external hex_ring_distances : h3_index -> int -> h3_index array * int array * int = "caml_hexRangeDistances"
external hex_ranges : h3_index array -> int -> int -> h3_index array * int = "caml_hexRanges"
external hex_ring : h3_index -> int -> h3_index array = "caml_hexRing"

let%test "test_degs_to_rads" = ((degs_to_rads 1.0) -. 0.0174533) < 0.0001
let%test "test_rads_to_degs" = ((rads_to_degs 1.0) -. 57.2958) < 0.0001
let%test "test_max_kring_size" = (max_kring_size 3) > 0
(* From the Examples: https://uber.github.io/h3/#/documentation/core-library/unix-style-filters
echo 40.689167 -74.044444 | geoToH3 5
852a1073fffffff
*)
let%test "test_geo_to_h3" = sprintf "%Lx" (geo_to_h3 (degs_to_rads 40.689167) (degs_to_rads (-74.044444)) 5) = "852a1073fffffff"
(*
echo 845ad1bffffffff | h3ToGeo
22.3204847179 169.7200239903
*)
let%test "test_h3_to_geo" = 
    let x = Scanf.sscanf "845ad1bffffffff" "%Lx" (fun s -> s) in
    let lat, lon = (h3_to_geo x) in
    ((lat -. 22.3204847179) < 0.0001) && ((lon -. 169.7200239903) < 0.0001)
