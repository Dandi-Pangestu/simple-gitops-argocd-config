#!/bin/bash

# exit when any command fails
set -e

new_ver=$1

echo "new version: $new_ver"

docker tag nginx:1.23.3 dandi96/nginx:$new_ver
docker push dandi96/nginx:$new_ver

tmp_dir=$(mktemp -d)
echo $tmp_dir

git clone git@github.com:Dandi-Pangestu/simple-gitops-argocd.git $tmp_dir

# Update image tag
sed -i '' -e "s/dandi96\/nginx:.*/dandi96\/nginx:$new_ver/g" $tmp_dir/my-app/1-deployment.yaml

# Commit and push
cd $tmp_dir
git add .
git commit -m "Upgrade nginx to $new_ver"
git push

rm -rf $tmp_dir