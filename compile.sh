#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
set -u
stage=$1
name=$2

# Some "name" do not correspond to packages.
# E.g. when building libstdc++, the package name is gcc
# this mapping permits to find the right source package for
# each artifact to build.
package=$name
case ${name} in
    libstdc++)
        package="gcc";;
esac

# Store the build logs in a separate directory
mkdir -pv ${LFS}/sources/build-logs/

while read line; do
    version=`echo $line | cut -d";" -f2`
    url=`echo $line | cut -d";" -f3`

    # URL format (from CSV) is <project>-@.tar.gz, or <project>@.tar.gz.
    # The script exploit the use of the version placeolder "@" to extract
    # the project's name.
    packagename=`basename ${url}`
    if [[ $packagename =~ "-@."  ]]; then
        project=${packagename%-@*}
    else if [[ $packagename =~ "@."  ]]; then
            project=${packagename%@*}
        else
            project=${packagename%%.*}
        fi
    fi
    # Remove the "@" placeolder from project's name where the
    # version is in the middle of the project name (e.g. python-x.y.z-doc)
    project=`echo ${project} | sed "s/@//g"`
    if [[ ${project} != ${package} ]]; then
        continue
    fi

    # Finally, complete the packagename replacing "@" with the version.
    packagename=`echo ${packagename} | sed "s/@/${version}/g"`

    if [[ -f ${LFS}/sources/${name}.built ]]; then
        log "Project ${project} already built"
        break
    fi

    # We will rely on build script for each project, since
    # the commandline to use may differ. Save the path to the script, before
    # moving inside ${LFS}/sources directory.
    build_script=`pwd`/build/${stage}/${name}.sh
    if [[ ! -f ${build_script} ]]; then
        err "Project ${project} does not have a ${stage} build script"
        exit 1
    fi
    pushd ${LFS}/sources

    # Extract the source
    if [[ ! -d ${project} ]]; then
        log "Extracting ${project}"
        mkdir -pv ${project}
        tar xf ${packagename} --directory=${project} 
    fi

    pushd ${project}
    # Some projects extract all the source files in the current directory,
    # others instead extract them in a root directory (usually called
    # project-name-<version>), which the script needs to get rid of.
    if [[ $(ls -1A | wc -l) == "1" ]]; then
        #echo "moving $(ls -1A) content here (`pwd`)"
        mv $(ls -1A)/* .
    fi

    # Build the project
    log_dir=${LFS}/sources/build-logs/${name}.log
    log "Building ${project} using $build_script (logs in ${log_dir})"
    source $build_script 2>&1 | tee ${log_dir}
    if [[ $? == 0 ]]; then
        log "Building ${name} done"
        touch ${LFS}/sources/${name}.built
    else
        err "Building ${name} failed"
    fi
    popd
    popd
done < packages.csv
