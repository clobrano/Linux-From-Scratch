#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
docker run --rm --volume /mnt/lfs:/mnt/lfs --volume `pwd`:/home/lfs/workspace -ti lfs
