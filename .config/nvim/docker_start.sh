#!/bin/sh

docker container run -i --rm --mount 'type=volume,source=nubots_generic_build,target=/home/nubots/build,consistency=delegated' --mount 'type=bind,source=/home/cameron/Documents/NUbots,target=/home/nubots/NUbots,consistency=cached' --workdir /home/nubots/NUbots nubots:selected clangd --compile-commands-dir=/home/nubots/build --background-index 2>/home/cameron/log.txt
