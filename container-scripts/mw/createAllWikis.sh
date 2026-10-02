#!/bin/bash
# Creates a wiki for every filtered dump, four at a time.
DIR="${1:-/data/project/wdump/math}"
DOP=4

if [ ! -d "$DIR" ]; then
	echo "Directory $DIR does not exist."
	exit 1
fi
mkdir -p "$DIR/log"
cd "$(dirname "$0")"

for dump in "$DIR"/*.xml.bz; do
	while (( $(jobs -rp | wc -l) >= DOP )); do wait -n; done
	name=$(basename "$dump")
	echo "processing $name"
	(./createWiki "$dump" &> "$DIR/log/$name.log" || echo "Error importing $name") &
done
wait
