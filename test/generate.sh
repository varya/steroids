#!/bin/sh

echo "this overwrites testApp/, okay?"
read
rm -rf testApp

steroids create testApp
cd testApp

CORDOVA_EXAMPLES="accelerometer audio camera compass device geolocation"
STEROIDS_EXAMPLES="animation drawer drumMachine layerStack modal navigationBar photoGallery preload"

rm -rf config/application.coffee
cp ../application.coffee.head config/application.coffee


for CORDOVA_EXAMPLE in $CORDOVA_EXAMPLES; do
	steroids generate example $CORDOVA_EXAMPLE

  echo "{" >> config/application.coffee
  echo "  title: '$CORDOVA_EXAMPLE'" >> config/application.coffee
  echo "  icon: ''" >> config/application.coffee
  echo "  location: '"$CORDOVA_EXAMPLE"Example.html'" >> config/application.coffee
  echo "}"  >> config/application.coffee
done

for STEROIDS_EXAMPLE in $STEROIDS_EXAMPLES; do
  steroids generate example $STEROIDS_EXAMPLE

  echo "{" >> config/application.coffee
  echo "  title: '$STEROIDS_EXAMPLE'" >> config/application.coffee
  echo "  icon: ''" >> config/application.coffee
  echo "  location: 'http://localhost/views/"$STEROIDS_EXAMPLE"Example/index.html'" >> config/application.coffee
  echo "}"  >> config/application.coffee
done

cat ../application.coffee.tail >> config/application.coffee

steroids connect