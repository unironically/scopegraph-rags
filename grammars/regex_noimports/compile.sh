#!/bin/sh

silver -I .. --onejar $@ regex_noimports:driver

rm build.xml > /dev/null 2>&1