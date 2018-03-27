type geo_coord = {lat: float; lon: float}
type geo_boundary = {num_verts: int; verts: geo_coord array}

external yo : unit -> int = "caml_yo"
external degs_to_rads : float -> float = "caml_degsToRads"
external rads_to_degs : float -> float = "caml_radsToDegs"
external geo_to_h3 : float -> float -> int -> int64 = "caml_geoToH3"
external h3_to_geo : int64 -> float * float = "caml_h3ToGeo"
external h3_to_geo_boundary : int64 -> geo_boundary = "caml_h3ToGeoBoundary"
external max_kring_size : int -> int = "caml_maxKringSize"
external k_ring : int64 -> int -> int64 array = "caml_kRing"
external k_ring_distances : int64 -> int -> int64 array * int array = "caml_kRingDistances"
