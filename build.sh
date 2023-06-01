#!/bin/bash

dir="$(cd -P -- "$(dirname -- "$0")" && pwd -P)"
cd $dir/web

sudo npm install -g pnpm
pnpm i
pnpm build
