#!/bin/sh
# requires $ sudo apt-get install mmv
cd /data/project/wdump/math-qid/
mmv \*wiki-latest-pages-articles-multistream.xml.bz2-chunk-1.xml.bz2-chunk-1.xml.bz2 \#1.xml.bz2
mmv \*_\* \#1-\#2