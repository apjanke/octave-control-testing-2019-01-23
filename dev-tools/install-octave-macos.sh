#!/bin/bash

set -x

if [[ "$OCTAVE_BLAS" == "openblas" ]]; then
	if [[ "$OCTAVE_VER" == "stable" ]]; then
		formula=octave-stable-openblas
	elif [[ "$OCTAVE_VER" == "default" ]]; then
		formula=octave-default-openblas
	elif [[ "$OCTAVE_VER" == "4.4" ]]; then
		formula=octave-openblas
	else
		echo &>2 Unsupported OCTAVE_VER: $OCTAVE_VER. Must be stable, default, or 4.4
	fi
else
	if [[ "$OCTAVE_VER" == "stable" ]]; then
		formula=octave-stable
	elif [[ "$OCTAVE_VER" == "default" ]]; then
		formula=octave-default
	elif [[ "$OCTAVE_VER" == "4.4" ]]; then
		formula=octave
	else
		echo &>2 Unsupported OCTAVE_VER: $OCTAVE_VER. Must be stable, default, or 4.4
	fi
fi

echo "Installing brew Octave formula: $formula"
brew install "$formula"
ln -s $(brew --prefix "$formula")/bin/octave ~/bin
ln -s $(brew --prefix "$formula")/bin/mkoctfile ~/bin


echo "Octave installation results:"
which octave
ls -l $(which octave)
which mkoctfile
ls -l $(which mkoctfile)