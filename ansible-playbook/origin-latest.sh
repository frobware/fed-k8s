#!/bin/bash

set -eu
set -o pipefail
#set -x

echo "copy to following lines into your openshift-ansible inventory file"
echo ""
BASEDIR=$(mktemp -d)
pushd $BASEDIR &>/dev/null
REPOURL=$(curl -s https://storage.googleapis.com/origin-ci-test/branch-logs/origin/master/builds/.latest)/artifacts/rpms
echo "openshift_additional_repos=[{'id': 'origin-devel', 'name': 'OpenShift Origin Development', 'baseurl': '$REPOURL', 'enabled': 1, 'gpgcheck': 0}]"
PRIMARY=$(curl -s $REPOURL/repodata/repomd.xml | grep -o repodata.*primary.xml | cut -f2 -d'/')
wget -q $REPOURL/repodata/$PRIMARY.gz
gzip -d $PRIMARY.gz
VERSION=$(grep -m 1 -o origin.*x86_64.rpm $PRIMARY | cut -f2,3 -d'-' | cut -f-7 -d'.')
echo "openshift_pkg_version=$VERSION"
echo ""
popd &>/dev/null
#rm -rf $BASEDIR
