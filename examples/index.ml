let printf = Printf.printf

let r2d = H3.rads_to_degs

let () =
    let lat = H3.degs_to_rads 40.689167 in
    let lon = H3.degs_to_rads (-74.044444) in
    let resolution = 10 in
    let indexed = H3.geo_to_h3 lat lon resolution in
    printf "The index is: %Lx\n" indexed;

    (* Get the vertices of the H3 index *)
    let boundary = H3.h3_to_geo_boundary indexed in
    Array.iteri
        (fun i x -> printf "Boundary vertex #%d: %f, %f\n" i (r2d x.H3.lat) (r2d x.H3.lon))
        boundary.H3.verts;

    let center_lat, center_lon = H3.h3_to_geo indexed in
    printf "Center coordinates: %f, %f\n" (r2d center_lat) (r2d center_lon)

(*
 * C output:
 * The index is: 8a2a1072b59ffff
 * Boundary vertex #0: 40.690059, 285.955848
 * Boundary vertex #1: 40.689908, 285.954938
 * Boundary vertex #2: 40.689271, 285.954659
 * Boundary vertex #3: 40.688785, 285.955289
 * Boundary vertex #4: 40.688936, 285.956199
 * Boundary vertex #5: 40.689573, 285.956479
 * Center coordinates: 40.689422, 285.955569
 *)
