#/bin/bash

fps=8
ffmpeg -r $fps -i "$1/fgout_%03d.png"  -filter_complex "scale=720:-1:flags=lanczos,split[a],palettegen,[a]paletteuse"  "fgout_$1.gif" -y

