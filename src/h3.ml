
type h3_index = int64

type geo_coord = {
    lat: float;
    lon: float
}

type geo_boundary = {
    num_verts: int;
    verts: geo_coord array
}

type geo_fence = {
    num_verts : int;
    verts : geo_coord array
}

type geo_polygon = {
    fence : geo_fence;
    num_holes : int;
    holes : geo_fence
}

external degs_to_rads : float -> float = "caml_degsToRads"
external rads_to_degs : float -> float = "caml_radsToDegs"
external h3_is_valid : h3_index -> int = "caml_h3IsValid"
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
external h3_get_resolution : h3_index -> int = "caml_h3GetResolution"
external h3_get_base_cell : h3_index -> int = "caml_h3GetBaseCell"
external string_to_h3 : string -> h3_index = "caml_stringToH3"
external hex_area_km2 : int -> float = "caml_hexAreaKm2"
external h3_indexes_are_neighbors : h3_index -> h3_index -> int = "caml_h3IndexesAreNeighbors"
