#!/bin/bash

yardoc -q './lib/**/*.rb' --private --readme README.md
printf "Looking for undocumented passages: \n"
yard stats './lib/**/*.rb' --list-undoc
