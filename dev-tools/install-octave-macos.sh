#!/bin/bash

set -x
set -e

# Gotta use our own "heartbeat" to prevent Travis timeouts because 
# travis_wait isn't available in the "install" stage

function start_heartbeat {
    if [ -n "$TRAVIS_CLIENT_SPINNER_PID" ]; then
        return
    fi

    >&2 echo "Working..."
    # Start a process that runs as a keep-alive
    # to avoid travis quitting if there is no output
    (while true; do
        sleep 60
        >&2 echo "Still working..."
    done) &
    TRAVIS_CLIENT_SPINNER_PID=$!
    disown
}

function stop_heartbeat {
    if [ ! -n "$TRAVIS_CLIENT_SPINNER_PID" ]; then
        return
    fi
    
    kill $TRAVIS_CLIENT_SPINNER_PID
    unset TRAVIS_CLIENT_SPINNER_PID

    >&2 echo "Work finished."
}

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
	# Use this instead of "brew install --only-dependencies $formula" to avoid
	# MacTeX dependency error
	deps=$(brew deps "$formula" --include-build)
	brew install $deps
	start_heartbeat
	brew install "$formula" --without-docs
	stop_heartbeat
fi

# Disgusting hack to make keg-only octaves visible as unqualified "octave" command
mkdir -p ~/bin
ln -s $(brew --prefix "$formula")/bin/octave ~/bin/octave
ln -s $(brew --prefix "$formula")/bin/mkoctfile ~/bin/mkoctfile

