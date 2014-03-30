#!/bin/bash -e

SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
T="$(mktemp -d --suffix .cloudify-chef-hello-world)"
[[ $T ]]
echo "+ Working in temp dir $T"


rsync -qaP "$SRC_DIR/cookbooks/" "$T/cookbooks/"

COOKBOOKS="apache2 https://github.com/opscode-cookbooks/apache2/archive/3c296b78bf916c41f8a257acc5da028f8fb5550a.tar.gz
iptables https://github.com/opscode-cookbooks/iptables/archive/64b2d48cf3062ad544395b915a4cb16b8e6e4bd3.tar.gz
logrotate https://github.com/stevendanna/logrotate/archive/84abf41065d6b57ec33215e74d1f24a13ab9da4e.tar.gz
pacman https://github.com/jesseadams/pacman/archive/3210e955268c733fdaa96d971f5cc761b632787e.tar.gz"

(
	cd "$T"
	while read cookbook_name cookbook_url;do
		echo "+ Downloading cookbook $cookbook_name"
		mkdir "cookbooks/$cookbook_name"
		wget -qO- "$cookbook_url" | tar --strip-components=1 -xzC "cookbooks/$cookbook_name"
	done <<<"$COOKBOOKS"
	echo "+ Creating cookbooks.tar.gz"
	tar czf cookbooks.tar.gz cookbooks
)

cp -a $T/cookbooks.tar.gz "$SRC_DIR/"

echo "+ Removing temporary directory $T"
rm -r "$T"
