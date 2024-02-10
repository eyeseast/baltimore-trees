DB = baltimore.db

SU = poetry run sqlite-utils

BBOX = -76.861861,39.096181,-76.360388,39.454149

PMTILES_BUILD = https://build.protomaps.com/20240210.pmtiles

install:
	poetry install

run:
	# https://docs.datasette.io/en/stable/settings.html#configuration-directory-mode
	poetry run datasette serve . --load-extension spatialite

data/trees-clean.csv: data/Trees.csv data/headers.txt
	cat data/headers.txt > $@
	cat data/Trees.csv | tail -n +2 >> $@

$(DB):
	$(SU) create-database $@ --enable-wal --init-spatialite

trees: $(DB) data/trees-clean.csv
	$(SU) insert $(DB) $@ data/trees-clean.csv --csv --detect-types

public/baltimore.pmtiles:
	pmtiles extract $(PMTILES_BUILD) $@ --bbox="$(BBOX)"

public/trees.pmtiles: data/trees-clean.csv
	tippecanoe -zg -o $@ --drop-densest-as-needed $^

tiles: public/baltimore.pmtiles public/trees.pmtiles
