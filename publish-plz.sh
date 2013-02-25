#!/bin/sh

echo "updating template projects to latest version with steroids-js"

sh update-steroidsjs-templates.sh 

echo "versioning the npm"

DEFAULTSEVERITY=patch
SEVERITY=${1:-$DEFAULTSEVERITY}

npm version $SEVERITY && git push && git push --tags && npm publish ./
