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

CAMLprim value caml_yo() { return Val_int(1); }
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
    printf("[C] lat=%f lon=%f\n", geo_coord.lat, geo_coord.lon);
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
        printf("[c] i=%d lat=%f lon=%f\n", i, gb.verts[i].lat, gb.verts[i].lon);
        this_tup = caml_alloc_tuple(2);
        Store_double_field(this_tup, 0, gb.verts[i].lat);
        Store_double_field(this_tup, 1, gb.verts[i].lon);
        Field(arr, i) = this_tup;
    }
    Field(ret, 0) = Val_int(gb.numVerts);
    Field(ret, 1) = arr;
    printf("[c] return!\n");
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
    // CAMLlocal2(ret, this_tup);
    printf("[c] caml_kRingDistances\n");
    fflush(stdout);
    int k = Int_val(caml_k);
    printf("[c] caml_kRingDistances %d\n", k);
    fflush(stdout);
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
        // Store_field(this_tup, 0, caml_copy_int64(rings[i]);
        // Store_field(this_tup, 1, distances[i]);
        // Field(ret, i) = this_tup;
    }
    Field(ret, 0) = neigh;
    Field(ret, 1) = dists;
    free(rings);
    free(distances);
    CAMLreturn(ret);
}
