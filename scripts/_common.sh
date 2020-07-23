#!/bin/bash

#=================================================
# COMMON VARIABLES
#=================================================

# dependencies used by the app
pkg_dependencies="mongodb mongodb-server mongo-tools"
pkg_dependencies_buster="mongodb-org mongodb-org-server mongodb-org-tools"
mongodb_stretch="mongodb"
mongodb_buster="mongod"
nodejsversion=12

#=================================================
# PERSONAL HELPERS
#=================================================

#=================================================
# EXPERIMENTAL HELPERS
#=================================================

ynh_detect_arch(){
	local architecture
	if [ -n "$(uname -m | grep arm64)" ] || [ -n "$(uname -m | grep aarch64)" ]; then
		architecture="arm64"
	elif [ -n "$(uname -m | grep 64)" ]; then
		architecture="x86-64"
	elif [ -n "$(uname -m | grep 86)" ]; then
		architecture="i386"
	elif [ -n "$(uname -m | grep arm)" ]; then
		architecture="arm"
	else
		architecture="unknown"
	fi
	echo $architecture
}


read_json () {
    sudo python3 -c "import sys, json;print(json.load(open('$1'))['$2'])"
}

read_manifest () {
    if [ -f '../manifest.json' ] ; then
        read_json '../manifest.json' "$1"
    else
        read_json '../settings/manifest.json' "$1"
    fi
}

abort_if_up_to_date () {
    version=$(read_json "/etc/yunohost/apps/$YNH_APP_INSTANCE_NAME/manifest.json" 'version' 2> /dev/null || echo '20160501-7')
    last_version=$(read_manifest 'version')
    if [ "${version}" = "${last_version}" ]; then
        ynh_print_info "Up-to-date, nothing to do"
        ynh_die "" 0
    fi
}

ynh_version_gt ()
{
    dpkg --compare-versions "$1" gt "$2"
}


#=================================================
# FUTURE OFFICIAL HELPERS
#=================================================
