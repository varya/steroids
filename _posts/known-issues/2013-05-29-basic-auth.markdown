---
layout: post
title:  "Basic Auth cache issues"
date:   2013-05-27 13:51:34
categories: 
platforms: ios
---

On both Android and iOS devices, HTTP Basic authentication requests are cached when posting them as part of the URL for the HTTP request. Thus, if I first make a request by POSTing

```
http://gooby:hello@example.com
```

and then try to POST

```
http://dolan:pls@example.com
```

the app still posts `http://gooby:hello@example.com`. To circumvent this, POST to the base URL only, and include the auth token as part of a header field:

{% highlight javascript %}
"Authorization": "Basic " + window.btoa(username+":"+password)
{% endhighlight %}