let printf = Printf.printf

let d2r = H3.degs_to_rads

let () =
    let austin_lat_rad = (H3.degs_to_rads 30.2672)  in
    let austin_lon_rad = (H3.degs_to_rads (-97.7431)) in
    printf "austin_lon_rad: %f\n" austin_lon_rad;
    let austin = H3.geo_to_h3 austin_lat_rad austin_lon_rad 12 in
    printf "Austin: %Lx\n" austin;
    let testo = H3.geo_to_h3 (d2r 40.689167) (d2r (-74.044444)) 5 in
    printf "Testo: %Lx\n" testo;
    let austin_geo_out = H3.h3_to_geo austin in
    printf "Austin Out Lat: %f Lon: %f\n" (fst austin_geo_out) (snd austin_geo_out);
    printf "Austin Out Lat: %f Lon: %f\n" (H3.rads_to_degs (fst austin_geo_out)) (H3.rads_to_degs (snd austin_geo_out));
    let gb = H3.h3_to_geo_boundary austin in
    printf "Austin GB num_verts: %d\n" gb.num_verts;
    printf "AL: %d\n" (Array.length gb.verts);
    let v0 = gb.verts.(0) in
    printf "%f %f\n" v0.lat v0.lon;
    printf "%f %f\n" gb.verts.(1).lat gb.verts.(1).lon;
    printf "%f %f\n" gb.verts.(2).lat gb.verts.(2).lon;
    printf "%f %f\n" gb.verts.(2).lat gb.verts.(2).lon;
    printf "maxKringSize: %d\n" (H3.max_kring_size 3);
    Array.iter (fun x -> printf "%Lx\n" x) (H3.k_ring austin 5);
    printf "---\n%!";
    let (neigh, dists) = (H3.k_ring_distances austin 5) in
    Array.iter (fun x -> printf "dist=%d\n" x) dists;
    ()
