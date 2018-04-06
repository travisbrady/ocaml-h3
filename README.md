# ocaml-h3: OCaml bindings to Uber's H3 geospatial indexing system
[![Build Status](https://travis-ci.org/travisbrady/ocaml-h3.svg?branch=master)](https://travis-ci.org/travisbrady/ocaml-h3)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)

### Summary
Experimental bindings to Uber's H3 C library for indexing geo points.

### Dependencies
First [install H3](https://github.com/uber/h3#install-build-time-dependencies) per the H3 readme instructions.

### Example

Simple example using utop.
First:
```
$ jbuilder utop src
```

Then within utop
```ocaml
utop # let paris = {H3.lat=48.8566; H3.lon=2.3522};;
val paris : H3.geo_coord = {H3.lat = 48.8566; lon = 2.3522}

utop # let paris_h3 = H3.h3_of_geo_coord paris 9;;
val paris_h3 : int64 = 617550903642685439L

utop # Printf.printf "%Lx" paris_h3;;
891fb466257ffff- : unit = ()
```

See also [examples/index.ml](examples/index.ml) and [examples/distance.ml](examples/distance.ml) which should exactly match
the [index.c](https://github.com/uber/h3/blob/master/examples/index.c) and [distance.c](https://github.com/uber/h3/blob/master/examples/distance.c)
in the upstream Uber H3 C library.
