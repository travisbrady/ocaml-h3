let printf = Printf.printf

let mean_earth_radius = 6371.0088

let haversine_distance th1 ph1 th2 ph2 =
    let ph1 = ph1 -. ph2 in
    let dz = (sin th1) -. (sin th2) in
    let dx = (cos ph1) *. (cos th1) -. (cos th2) in
    let dy = (sin ph1) *. (cos th1) in
    (asin (sqrt(dx *. dx +. dy *. dy +. dz *. dz)) /. 2.0) *. 2.0 *. mean_earth_radius

let () =
    let uber_h3HQ1 = H3.string_to_h3 "8f2830828052d25" in
    let uber_h3HQ2 = H3.string_to_h3 "8f283082a30e623" in

    let hq1_lat, hq1_lon = H3.h3_to_geo uber_h3HQ1 in
    let hq2_lat, hq2_lon = H3.h3_to_geo uber_h3HQ2 in

    printf "origin: (%f, %f)\n" (H3.rads_to_degs hq1_lat) (H3.rads_to_degs hq1_lon);
    printf "destination: (%f, %f)\n" (H3.rads_to_degs hq2_lat) (H3.rads_to_degs hq2_lon);
    printf "distance: %fkm\n" (haversine_distance hq1_lat hq1_lon hq2_lat hq2_lon)


(*
 * C output `./distance`
origin: (37.775236, 237.580245)
destination: (37.789991, 237.597879)
distance: 2.256853km
*)

