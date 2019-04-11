#!/bin/bash
pandoc -t revealjs -s pacman.md -o pacman.html \
	-V theme=solarized \
	-V transition=cube \
	--include-in-header custom.css \
	--slide-level 1
