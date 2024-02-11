# Baltimore trees

This is a demo project for [NICAR24], showing the location of trees in the city of Baltimore, layered on a self-hosted street map. Everything the map needs to run is in this repository. Once dependencies are installed, it should run without an internet connection.

## Getting started

The `Makefile` in this project contains all the steps to build both a map and a Datasette instance to explore the underlying data.

To build and run everything, use the following commands:

```sh
# install both Python and JS dependencies
make install

# build the database
make trees

# download and build tiles
make tiles

# run both servers
make run
```

These commands depend on having Python, Poetry, the PMTiles CLI and Tippecanoe installed locally. To just see the finished map, run the following commands:

```sh
npm ci
npm run dev -- --open
```

## Tiles and basemap

[Protomaps] offers free [basemaps](https://maps.protomaps.com/builds/) built on [OpenStreetMap](https://www.openstreetmap.org/).

I used [this site](https://boundingbox.klokantech.com/) to find a bounding box of the area around Baltimore, and then the `pmtiles` CLI to extract tiles for that area.

```sh
pmtiles extract https://build.protomaps.com/20240211.pmtiles public/baltimore.pmtiles --bbox="-76.861861,39.096181,-76.360388,39.454149
```

## Tree data

The City of Baltimore publishes a [public tree inventory](https://baltimore.maps.arcgis.com/apps/webappviewer/index.html?id=d2cfbbe9a24b4d988de127852e6c26c8) on its [data portal](https://data.baltimorecity.gov/). Running `make data/trees.ndjson` will use a Python script to download the full dataset as newline-delimited GeoJSON.

[Datasette](https://datasette.io/) offers a way to quickly explore data, including with maps. The `Makefile` in this project includes commands to build an SQLite database with SpatiaLite and run a Datasette instance.

```sh
# build the database, downloading data if needed
make trees

# run the server
make run
```

## Further reading

- [Protomaps]
- [PMTiles]
- [PMTiles CLI]
- [MapLibre]

[NICAR24]: https://www.ire.org/training/conferences/nicar-2024/
[Protomaps]: https://protomaps.com/
[PMTiles]: https://docs.protomaps.com/pmtiles/
[PMTiles CLI]: https://docs.protomaps.com/pmtiles/cli
[MapLibre]: https://maplibre.org/
