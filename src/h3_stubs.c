#define CAML_NAME_SPACE

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <h3/h3api.h>

#include <caml/alloc.h>
#include <caml/callback.h>
#include <caml/fail.h>
#include <caml/memory.h>
#include <caml/mlvalues.h>

CAMLprim value caml_degsToRads(value caml_degrees) {
    return caml_copy_double(degsToRads(Double_val(caml_degrees)));
}

CAMLprim value caml_radsToDegs(value caml_radians) {
    return caml_copy_double(radsToDegs(Double_val(caml_radians)));
}

CAMLprim value caml_hexAreaKm2(value caml_res) {
    return caml_copy_double(Int_val(caml_res));
}

CAMLprim value caml_h3IsValid(value caml_h3) {
    return Val_int(Int64_val(caml_h3));
}

CAMLprim value caml_geoToH3(value caml_lat, value caml_lon, value caml_res) {
    GeoCoord geo_coord = {.lat = Double_val(caml_lat),
                          .lon = Double_val(caml_lon)};
    uint64_t res = geoToH3(&geo_coord, Int_val(caml_res));
    return caml_copy_int64(res);
}

CAMLprim value caml_h3ToGeo(value caml_h3) {
    CAMLparam1(caml_h3);
    CAMLlocal1(ret);
    GeoCoord geo_coord = {.lat = 0.0, .lon = 0.0};
    h3ToGeo(Int64_val(caml_h3), &geo_coord);
    ret = caml_alloc_tuple(2);
    Field(ret, 0) = caml_copy_double(geo_coord.lat);
    Field(ret, 1) = caml_copy_double(geo_coord.lon);
    CAMLreturn(ret);
}

CAMLprim value caml_h3ToGeoBoundary(value caml_h3) {
    CAMLparam1(caml_h3);
    CAMLlocal3(ret, arr, this_tup);
    GeoBoundary gb;
    h3ToGeoBoundary(Int64_val(caml_h3), &gb);
    ret = caml_alloc_tuple(2);
    arr = caml_alloc(gb.numVerts, Abstract_tag);
    for (int i = 0; i < gb.numVerts; i++) {
        this_tup = caml_alloc_tuple(2);
        Store_double_field(this_tup, 0, gb.verts[i].lat);
        Store_double_field(this_tup, 1, gb.verts[i].lon);
        Field(arr, i) = this_tup;
    }
    Field(ret, 0) = Val_int(gb.numVerts);
    Field(ret, 1) = arr;
    CAMLreturn(ret);
}

CAMLprim value caml_maxKringSize(value caml_k) {
    return Val_int(maxKringSize(Int_val(caml_k)));
}

CAMLprim value caml_kRing(value caml_h3, value caml_k) {
    CAMLparam2(caml_h3, caml_k);
    CAMLlocal1(ret);
    int k = Int_val(caml_k);
    H3Index* rings = (H3Index*)calloc(k, sizeof(H3Index));
    kRing(Int64_val(caml_h3), k, rings);
    ret = caml_alloc_tuple(k);
    for (int i = 0; i < k; i++) {
        Store_field(ret, i, caml_copy_int64(rings[i]));
    }
    free(rings);
    CAMLreturn(ret);
}

CAMLprim value caml_kRingDistances(value caml_h3, value caml_k) {
    CAMLparam2(caml_h3, caml_k);
    CAMLlocal3(ret, neigh, dists);
    int k = Int_val(caml_k);
    H3Index* rings = (H3Index*)calloc(k, sizeof(H3Index));
    int* distances = (int*)calloc(k, sizeof(int));
    kRingDistances(Int64_val(caml_h3), k, rings, distances);
    ret = caml_alloc_tuple(2);
    neigh = caml_alloc_tuple(k);
    dists = caml_alloc_tuple(k);
    ret = caml_alloc(k, Abstract_tag);
    for (int i = 0; i < k; i++) {
        Field(neigh, i) = caml_copy_int64(rings[i]);
        Field(dists, i) = distances[i];
    }
    Field(ret, 0) = neigh;
    Field(ret, 1) = dists;
    free(rings);
    free(distances);
    CAMLreturn(ret);
}

CAMLprim value caml_hexRange(value v_origin, value v_k) {
    H3Index out;
    int res = hexRange(Int64_val(v_origin), Int_val(v_k), &out);
    return caml_copy_int64(out);
}

CAMLprim value caml_hexRangeDistances(value v_origin, value v_k) {
    CAMLparam2(v_origin, v_k);
    CAMLlocal3(ret, neigh, dists);
    int k = Int_val(v_k);
    H3Index* rings = (H3Index*)calloc(k, sizeof(H3Index));
    int* distances = (int*)calloc(k, sizeof(int));
    int res = hexRangeDistances(Int64_val(v_origin), k, rings, distances);
    ret = caml_alloc_tuple(3);
    neigh = caml_alloc_tuple(k);
    dists = caml_alloc_tuple(k);
    ret = caml_alloc(k, Abstract_tag);
    for (int i = 0; i < k; i++) {
        Field(neigh, i) = caml_copy_int64(rings[i]);
        Field(dists, i) = distances[i];
    }
    Field(ret, 0) = neigh;
    Field(ret, 1) = dists;
    Field(ret, 2) = res;
    free(rings);
    free(distances);
    CAMLreturn(ret);
}

CAMLprim value caml_hexRanges(value v_h3Set, value v_length, value v_k) {
    CAMLparam3(v_h3Set, v_length, v_k);
    CAMLlocal2(ret_array, ret);
    int length = Int_val(v_length);
    int k = Int_val(v_k);
    H3Index* out = (H3Index*)calloc(k, sizeof(H3Index));
    int res = hexRanges((H3Index*)Int64_val(v_h3Set), length, k, out);
    ret_array = caml_alloc_tuple(k);
    ret = caml_alloc_tuple(2);
    for (int i = 0; i < k; i++) {
        Field(ret_array, i) = caml_copy_int64(out[i]);
    }
    Field(ret, 0) = ret_array;
    Field(ret, 1) = res;
    free(out);
    CAMLreturn(ret);
}

CAMLprim value caml_hexRing(value v_origin, value v_k) {
    CAMLparam2(v_origin, v_k);
    CAMLlocal2(ret_array, ret);
    int k = Int_val(v_k);
    H3Index* out = (H3Index*)calloc(k, sizeof(H3Index));
    int res = hexRing(Int64_val(v_origin), Int_val(v_k), out);
    ret_array = caml_alloc_tuple(k);
    ret = caml_alloc_tuple(2);
    for (int i = 0; i < k; i++) {
        Field(ret_array, i) = caml_copy_int64(out[i]);
    }
    Field(ret, 0) = ret_array;
    Field(ret, 1) = res;
    free(out);
    CAMLreturn(ret);
}
