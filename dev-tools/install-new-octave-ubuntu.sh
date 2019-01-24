#!/bin/bash
#
# This installs Octave on Ubuntu, doing what's necessary to get a newer 4.2
# Octave even if this distro's default is an older version.


function install_octave_4_2_from_apt () {
	if grep -i 'xenial\|trusty' /etc/lsb-release &>/dev/null; then
		echo $0: Adding apt repository ppa:octave/stable to get newer Octave 4.2
		sudo add-apt-repository ppa:octave/stable --yes
		sudo apt-get update
	fi
	pkgs="octave liboctave-dev"
	echo $0: Installing packages: $pkgs
	sudo apt-get install --yes $pkgs
}

function install_octave_4_4_from_flatpak () {
	echo $0: installing flatpak
	if grep -i 'xenial\|trusty' /etc/lsb-release &>/dev/null; then
		echo $0: Adding apt repository ppa:octave/stable to get newer Octave 4.2
		sudo add-apt-repository ppa:alexlarsson/flatpak --yes
		sudo apt-get update
	fi
	sudo apt-get install --yes flatpak

	sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
	sudo flatpak install -y flathub org.octave.Octave
	# Super duper hack to get this flatpak octave and mkoctfile on the path
	octave_dir=$(flatpak info org.octave.Octave | grep Location | cut -d ":" -f 2 | cut -d " " -f 2)
	echo "" >> ~/.bash_profile
	echo "PATH=$octave_dir/files/bin:$PATH" >> ~/.bash_profile
	echo "$octave_dir" > ~/octave_dir.txt
}

case $OCTAVE_VER in
	4.2)
		install_octave_4_2_from_apt
		;;
	4.4)
		install_octave_4_4_from_flatpak
		;;
	*)
		echo >&2 $0: error: do not know how to install Octave version '$OCTAVE_VERSION'
		;;
esac
