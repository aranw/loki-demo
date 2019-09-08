#!/bin/sh

set -e 

sh promtail.sh

exec ./app
