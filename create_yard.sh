#!/bin/bash
# @Author: Benjamin Held
# @Date:   2015-08-30 09:48:37
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2017-12-04 19:07:42

yard doc -q --private --readme ./README.md
printf "Looking for undocumented passages: \n"
yard stats --list-undoc
