#!/bin/bash
ffmpeg -y -i fig_slp/slp_jaguar5_%03d.png -vf palettegen palette.png && \
ffmpeg -y -r 30 -i fig_slp/slp_jaguar5_%03d.png -i palette.png -filter_complex paletteuse slp_jaguar5.gif && \
rm palette.png
