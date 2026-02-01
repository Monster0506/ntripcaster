#!/bin/bash

# Start ntripcaster in the background
/usr/local/ntripcaster/bin/casterwatch &

# Start nginx in the foreground
nginx -g 'daemon off;'
