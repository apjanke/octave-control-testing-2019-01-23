#!/bin/bash

set -x

bottle=0
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
		bottle=1
	else
		echo &>2 Unsupported OCTAVE_VER: $OCTAVE_VER. Must be stable, default, or 4.4
	fi
fi

echo "Installing brew Octave formula: $formula"
if [[ $bottle == 1 ]]; then
	brew install "$formula"
else
	brew install --only-dependencies "$formula"
	# Gotta use --verbose to prevent Travis from timing out
	brew install --verbose "$formula" --without-docs
fi
ln -s $(brew --prefix "$formula")/bin/octave ~/bin
ln -s $(brew --prefix "$formula")/bin/mkoctfile ~/bin


echo "Octave installation results:"
brew info "$formula"
which octave
ls -l $(which octave)
which mkoctfile
ls -l $(which mkoctfile)