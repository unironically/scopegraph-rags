#!/bin/sh

silver -I .. --onejar $@ lmr_scopefunctions:driver

rm build.xml > /dev/null 2>&1