#!/usr/bin/env python3
"""
Download features from ArcGIS and write out newline-delimited geojson
"""

import json
import pathlib
import httpx

outfile = pathlib.Path("data/trees.ndjson")

url = "https://services1.arcgis.com/UWYHeuuJISiGmgXx/arcgis/rest/services/Trees_12052017/FeatureServer/0/query"

base_params = {
    "f": "json",
    "where": "1=1",
    "returnGeometry": "true",
    "inSR": "102100",
    "outFields": "ID,LOC_TYPE,SPP,COMMON,SPACE_TYPE,Address,Street,Side,DBH,MULTI_STEM,TREE_HT,SPCELENGTH,SPACEWIDTH,UTILITIES,HARD_SCAPE,CULTIVAR,Inv_Date,Notes,X_COORD,Y_COORD",
    "orderByFields": "ID ASC",
    "outSR": "4326",
    "resultOffset": 0,
    "resultRecordCount": 2000,
}

per_page = 2000


def main():
    page = 0
    with httpx.Client() as client, outfile.open("w", encoding="utf-8") as sink:
        while True:
            params = base_params.copy()
            params["resultOffset"] = per_page * page
            params["resultRecordCount"] = per_page

            print(f"Downloading page {page}")
            r = client.get(url, params=params)

            if not r.status_code == 200:
                print(f"Response error: {r.status_code}")
                return

            data = r.json()
            features = data["features"]

            if len(features) == 0:
                print("No features left. Done.")
                return

            for f in features:
                feature = {
                    "type": "Feature",
                    "properties": f["attributes"],
                    "geometry": {
                        "type": "Point",
                        "coordinates": [f["geometry"]["x"], f["geometry"]["y"]],
                    },
                }

                sink.write(json.dumps(feature) + "\n")

            page += 1


if __name__ == "__main__":
    main()
