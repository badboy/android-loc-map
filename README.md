Visualize your Android Location Cache data on Google Maps
=========================================================

This is a simple demo webpage that helps you plotting the location cached data 
collected by your android smartphone.

Your Cache file is only parsed server-side, the map is rendered using Google Maps API.

Nothing is stored server-side, I was just to lazy to get binary-parsing working in the browser :P

The files are named `cache.cell` & `cache.wifi` and is located in
`/data/data/com.google.android.location/files` on the Android device.

For more info see [packetlss/android-locdump](https://github.com/packetlss/android-locdump) (that's where I got the parsing code from).

Thanks to [Mark Olson](https://github.com/markolson) and [William Edwards](https://github.com/williame)
for [js-sqlite-map-thing](https://github.com/markolson/js-sqlite-map-thing)

***[You can view this script online here on heroku](http://android-loc-map.heroku.com/)***,
or copy the code and run it on your own server.
