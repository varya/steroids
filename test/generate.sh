#!/bin/sh

echo "this overwrites testApp/, okay?"
read
rm -rf testApp

steroids create testApp
cd testApp

CORDOVA_EXAMPLES="accelerometer audio camera compass device geolocation notification storage"
STEROIDS_EXAMPLES="animation drawer drumMachine layerStack modal navigationBar photoGallery preload"

# Generate cordovaIndex.html

cp ../test/index.html.head www/cordovaIndex.html

echo "    <h2 class='topcoat-list__header'>Cordova Examples</h2>" >> www/cordovaIndex.html
echo "    <ul class='topcoat-list'>" >> www/cordovaIndex.html

for CORDOVA_EXAMPLE in $CORDOVA_EXAMPLES; do
  steroids generate example $CORDOVA_EXAMPLE

  echo "      <li class='topcoat-list__item' data-location='"$CORDOVA_EXAMPLE"Example.html'>" >> www/cordovaIndex.html
  echo "       "$CORDOVA_EXAMPLE >> www/cordovaIndex.html
  echo "      </li>" >> www/cordovaIndex.html
done

cat ../test/index.html.tail >> www/cordovaIndex.html

# Generate steroidsIndex.html

cp ../test/index.html.head www/steroidsIndex.html

echo "    <h2 class='topcoat-list__header'>Steroids Examples</h2>" >> www/steroidsIndex.html
echo "    <ul class='topcoat-list'>" >> www/steroidsIndex.html

for STEROIDS_EXAMPLE in $STEROIDS_EXAMPLES; do
  steroids generate example $STEROIDS_EXAMPLE

  echo "      <li class='topcoat-list__item' data-location='http://localhost/views/"$STEROIDS_EXAMPLE"Example/index.html'>" >> www/steroidsIndex.html
  echo "       "$STEROIDS_EXAMPLE >> www/steroidsIndex.html
  echo "      </li>" >> www/steroidsIndex.html
done

cat ../test/index.html.tail >> www/steroidsIndex.html

# Overwrite config/application.coffee

rm -rf config/application.coffee
cp ../test/application.coffee config/application.coffee


steroids connect
