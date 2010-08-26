#!/bin/sh
editor=${EDITOR:-vi}
version=`cat VERSION`

$editor VERSION                                  &&
version=`cat VERSION`                            &&
git commit -am "v$version release"               &&
git tag v`cat VERSION`                           &&
git push github master                           &&
git push --tags github                           &&
git push production master                       &&
printf "Now, update VERSION to ($version+1).rc1" &&
read x                                           &&
$editor VERSION                                  &&
git commit -am "post v$version release"
