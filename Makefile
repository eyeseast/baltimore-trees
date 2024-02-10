DB = baltimore.db

SU = poetry run sqlite-utils

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
