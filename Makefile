DB = baltimore.db

SU = poetry run sqlite-utils

BBOX = -76.861861,39.096181,-76.360388,39.454149

TODAY = $(shell date +%Y%m%d)
PMTILES_BUILD = https://build.protomaps.com/$(TODAY).pmtiles

install:
	poetry install
	npm ci

tiles: public/baltimore.pmtiles public/trees.pmtiles

trees: $(DB) data/trees-clean.csv
	$(SU) insert $(DB) $@ data/trees-clean.csv --csv --detect-types

run:
	# https://docs.datasette.io/en/stable/settings.html#configuration-directory-mode
	npm run dev -- --open & poetry run datasette serve . --load-extension spatialite

clean:
	rm -f $(DB) $(DB)-shm $(DB)-wal public/*.pmtiles

data/trees-clean.csv: data/Trees.csv data/headers.txt
	cat data/headers.txt > $@
	cat data/Trees.csv | tail -n +2 >> $@

$(DB):
	$(SU) create-database $@ --enable-wal --init-spatialite

public/baltimore.pmtiles:
	pmtiles extract $(PMTILES_BUILD) $@ --bbox="$(BBOX)"

public/trees.pmtiles: data/trees-clean.csv
	tippecanoe -zg -o $@ --drop-densest-as-needed $^
