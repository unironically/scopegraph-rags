#!/bin/sh

silver -I .. --mwda --onejar $@ lm_resolve1:driver

rm build.xml > /dev/null 2>&1