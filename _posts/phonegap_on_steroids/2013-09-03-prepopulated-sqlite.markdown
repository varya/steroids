---
layout: post
title:  "Using a local prepopulated SQLite database (iOS)"
date:   2013-06-12 13:51:34
categories: phonegap_on_steroids
platforms: iOS
---

This guide uses the [SQLite iOS plugin](https://github.com/pgsqlite/PG-SQLitePlugin-iOS), included with AppGyver Scanner. You need to download the appropriate JavaScript files from the [steroids-plugins](https://github.com/AppGyver/steroids-plugins/tree/master/sqlite/www) GitHub repo and load them into your project.

If you need a test database, the [Chinook Database](http://chinookdatabase.codeplex.com/releases/view/55681) is a good choice (and used in the code examples below).

The `sqliteplugin.js` (in the Steroids plugin repository) defines a `window.sqlitePlugin` object. The syntax to use it is very similar to the Cordova [Storage API](http://docs.appgyver.com/en/edge/cordova_storage_storage.md.html#Storage) (which uses vanilla SQL) – you can read more about the plugin at the SQLite plugin's [official GitHub repo](https://github.com/pgsqlite).

On iOS, the SQLite plugin creates databases by default to the user files folder of your application, i.e. `Documents/`. Thus, to load the database, we are going to use the `steroids.app.path` to get the relative path to our database file. Since we are using Cordova, and `steroids.app` properties depend on the Steroids `ready` event, we need to wrap our code in two event listeners.

*The difference between user files folder and app files folder may be a bit confusing and will be explained in depth in an upcoming guide. Basically, the contents of the `dist/` folder go to the read-only app files folder (`steroids.app.absolutePath` on the device), whereas the user files folder (`steroids.app.absoluteUserFilesPath` on the device) is writeable during app runtime.*

{% highlight javascript %}
var db;

document.addEventListener("deviceready", onDeviceReady);

function onDeviceReady() {
  steroids.on("ready", initDatabase);
}

function initDatabase() {
  var dbPath = steroids.app.path + "/data/Chinook_Sqlite.sqlite"
  db = window.sqlitePlugin.openDatabase({name: dbPath});
}
{% endhighlight %}

The SQLite plugin works so that if there is a database file corresponding to the `name` property, then that existing database is used. Otherwise, a new empty database file is created with the given filename.

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
  for (var i=0; i&lt;len; i++){
    result += ("Name =  " + results.rows.item(i).Name + "\n");
  }
  navigator.notification.alert(result, null, "Database query successful!");
}
{% endhighlight %}

### Modifying prepopulated databases during runtime

Note that since the SQLite database is now in the app file directory (which changes each time you update changes to your phone in order to circumvent cache issues, and is read-only), inserts into the database won't work. If you need to modify the database and not just read from it, it should be in the `steroids.app.absoluteUserFilesPath` path. You need to copy it there (e.g. via Cordova's [File API](http://docs.appgyver.com/en/edge/cordova_file_file.md.html#File)) when the app first starts and then open it from that directory.

You can also view an [example project on GitHub](https://github.com/AppGyver/academy-examples/tree/master/deeper_into_steroids/prepopulated_sqlite).