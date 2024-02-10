import maplibregl from "maplibre-gl";
import * as pmtiles from "pmtiles";
import layers from "protomaps-themes-base";

const protocol = new pmtiles.Protocol();

maplibregl.addProtocol("pmtiles", protocol.tile);

const style = {
  version: 8,
  glyphs:
    "https://protomaps.github.io/basemaps-assets/fonts/{fontstack}/{range}.pbf",
  sources: {
    protomaps: {
      type: "vector",
      url: "pmtiles://" + "baltimore.pmtiles",
      attribution:
        '<a href="https://protomaps.com">Protomaps</a> © <a href="https://openstreetmap.org">OpenStreetMap</a>',
    },
  },
  layers: layers("protomaps", "light"),
};

const map = new maplibregl.Map({
  container: "map",
  style,
  maxBounds: [-76.861861, 39.096181, -76.360388, 39.454149],
});

window.map = map;
