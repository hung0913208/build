#!/bin/bash

unameOut="$(uname -s)"
case "${unameOut}" in
	Linux*)	        machine=Linux;;
	Darwin*)        machine=Mac;;
	CYGWIN*)        machine=Cygwin;;
	MINGW*)	        machine=MinGw;;
	FreeBSD*)       machine=FreeBSD;;
	*)              machine="UNKNOWN:${unameOut}"
esac

if [ "$machine" == "Linux" ] || [ "$machine" == "FreeBSD" ]; then
	SU=""
	SYS=""
	INSTALL=""

	# @NOTE: check root if we didn"t have root permission
	if [ $(whoami) != "root" ]; then
		if [ ! $(which sudo) ]; then
			error "Sudo is needed but you aren't on root and can't access to root"
		fi

		if sudo -S -p "" echo -n < /dev/null 2> /dev/null ; then
			SU="sudo"
		else
			error "Sudo is not enabled"
		fi
	fi

	# @NOTE: check and set INSTALL tool
	if which apt-get >& /dev/null; then
		$SU apt update
		$SU apt install curl
		curl https://bazel.build/bazel-release.pub.gpg | $SU apt-key add -
		echo "deb [arch=amd64] https://storage.googleapis.com/bazel-apt stable jdk1.8" | $SU tee /etc/apt/sources.list.d/bazel.list
	elif which apt >& /dev/null; then
		$SU apt install curl
		curl https://bazel.build/bazel-release.pub.gpg | $SU apt-key add -
		echo "deb [arch=amd64] https://storage.googleapis.com/bazel-apt stable jdk1.8" | $SU tee /etc/apt/sources.list.d/bazel.list
	fi
elif [ "$machine" == "Mac" ]; then
	SU=""
	INSTALL="brew install"
	SYS="osx"

	# @NOTE: check and set INSTALL tool
	if [ ! $(which brew) ]; then
		error "Please install brew before run anything on you OSX system"
	fi
else
	echo "I don't support this machine ${machine}"
	echo "You can send me an email to hung0913208@gmail.com"
	echo "Thanks"
	echo "Hung"
	echo ""
	exit -1
fi

