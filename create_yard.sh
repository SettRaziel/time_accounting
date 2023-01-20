#!/bin/bash

yard doc -q --private --readme ./README.md
printf "Looking for undocumented passages: \n"
yard stats --list-undoc
