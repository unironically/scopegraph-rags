#!/bin/sh

silver -I .. --mwda --onejar $@ regex_noimports:driver

rm build.xml > /dev/null 2>&1