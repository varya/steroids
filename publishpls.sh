#!/bin/sh

npm version patch && git push --tags && npm publish
