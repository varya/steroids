---
layout: post
title:  "Using a local prepopulated SQLite database (iOS)"
date:   2013-06-12 13:51:34
categories: phonegap_on_steroids
platforms: iOS, Android
---

This guide uses the [Cordova SQLitePlugin](https://github.com/lite4cordova/Cordova-SQLitePlugin), included with AppGyver Scanner. Note that the version of the plugin used by Steroids is slightly modified; you need to download the appropriate JavaScript files from the [steroids-plugins](https://github.com/AppGyver/steroids-plugins/tree/master/sqlite/www) GitHub repo and load them into your project manually instead of using the ones from the official repo.

If you need a test database, the [Chinook Database](http://chinookdatabase.codeplex.com/releases/view/55681) is a good choice (and used in the code examples below).

The `sqliteplugin.js` (in the Steroids plugin repository) defines a `window.sqlitePlugin` object. The syntax to use it is very similar to the Cordova [Storage API](http://docs.appgyver.com/en/edge/cordova_storage_storage.md.html#Storage) (which uses vanilla SQL).

## Setting up your local database

For the example below, we'll put the local database file to `www/data/Chinook_Sqlite.sqlite` in your Steroids project

On iOS, the SQLite plugin looks for databases in the User Files folder of your application, i.e. `Documents/`. Thus, to load the database from the App folder, we are going to use the `steroids.app.path` to get the relative path to our database file. On Android, we are going to use the full File URL and `steroids.app.absolutePath`. (Read more about the User Files and App folders in the [App Structure on the Device Guide][app-structure-on-device].)

Since we are using Cordova, and `steroids.app` properties depend on the Steroids `ready` event, we need to wrap our code in two event listeners.

{% highlight javascript %}
var db;

document.addEventListener("deviceready", onDeviceReady);

function onDeviceReady() {
  steroids.on("ready", initDatabase);
}

function initDatabase() {

  if ( device.platform == "Android") {
    var dbName = "file://" + steroids.app.absolutePath + "/data/Chinook_Sqlite.sqlite"
  } else {
    var dbName = steroids.app.path + "/data/Chinook_Sqlite.sqlite";
  }

  db = window.sqlitePlugin.openDatabase({name: dbPath});
}
{% endhighlight %}

The SQLite plugin works so that if there is a database file in the path corresponding to the `name` property, then that existing database is used. Otherwise, a new empty database file is created with the given filename.

You can then run a query on the database – the example code queries the `ARTISTS` table:

{% highlight javascript %}
function runQuery() {
  db.transaction(queryDB, databaseError);
}

// Query the database
function queryDB(tx) {
  tx.executeSql('SELECT * FROM ARTIST', [], gotQueryResults, databaseError);
}

// Show the results of the database query
function gotQueryResults(tx, results) {
  var len = results.rows.length;
  var result = "";
  result += ("Artist table: " + len + " rows found. \n\n");
  for (var i=0; i<len; i++){
    result += ("Name =  " + results.rows.item(i).Name + "\n");
  }
  navigator.notification.alert(result, null, "Database query successful!");
}
{% endhighlight %}

## Modifying prepopulated databases during runtime

Note that since the SQLite database is now in the app file directory (which changes each time you update changes to your phone in order to circumvent cache issues, and is read-only), inserts into the database won't be saved. If you need to modify the database and not just read from it, you should keep it in the `steroids.app.absoluteUserFilesPath` path. You need to copy it there (e.g. via Cordova's [File API](http://docs.appgyver.com/en/edge/cordova_file_file.md.html#File)) when the app first starts and then open it from that directory.

You can view an [example project on GitHub](https://github.com/AppGyver/academy-examples/tree/master/deeper_into_steroids/prepopulated_sqlite) for iOS.

## Downloading and using an external database

You can also easily use an external database on a remote server: simply download it with e.g. Cordova's [File API](http://docs.appgyver.com/en/edge/cordova_file_file.md.html#File) and pass the downloaded database file's location to the SQLitePlugin.