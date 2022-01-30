#!/bin/bash
ffmpeg -y -i _plots/surf_%03d.png -vf palettegen palette.png && \
ffmpeg -y -r 4 -i _plots/surf_%03d.png -i palette.png -filter_complex paletteuse _plots/surf.gif && \
rm palette.png

ffmpeg -y -i _plots/surf_topo3_%03d.png -vf palettegen palette.png && \
ffmpeg -y -r 4 -i _plots/surf_topo3_%03d.png -i palette.png -filter_complex paletteuse _plots/surf_topo3.gif && \
rm palette.png
