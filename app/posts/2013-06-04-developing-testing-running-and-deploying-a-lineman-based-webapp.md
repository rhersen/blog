---
title: "Developing, testing and running a Lineman-based webapp"
date: "2013-06-04 07:27"
---

[Lineman](https://github.com/testdouble/lineman) is a node.js-based
tool that greatly facilitates writing Javascript-based web
applications.  Lineman was created by Justin Searls,
co-founder of the software studio Test Double.
This is a short howto aiming at conveying how
easy it is to get a webapp up and running with Lineman.

Start by installing Lineman (I'm just going to blatantly assume that
you've already installed node.js):

```bash
sudo npm install -g lineman
```

and now you're able to create a scaffolded project as a starting point:

```bash
lineman new proj
cd proj/
```

where `proj` is the name of your new project.
If everything went well, you should be able to do

```bash
lineman run
```

and open up [localhost:8000](http://localhost:8000)
in your favourite browser to see a well-known greeting.
In another terminal window, do

```bash
lineman spec
```

and Lineman will start the
[Testem](https://github.com/airportyh/testem) runner.
Now you can start editing your test files (`spec/*.js`)
and source files (`app/js/*.js`),
and whenever you save a file,
Lineman will both run your tests
and update the application running on
[localhost:8000](http://localhost:8000).

The really cool thing with Testem is that you
can run the tests in several browsers at the same time, simply by
accessing the URL shown by Testem, which usually is
[localhost:7357](http://localhost:7357).
This even works on other
machines, for example on Android phones or tablets connected to your
local network (but in that case you of course have to replace
`localhost` in the URL with your IP number).

Lineman has out-of-the-box support for Coffeescript, and since it's
based on grunt, you can add support for other languages as well.
Another nifty feature is backend proxying, which is described in more
detail in the official documentation, but basically it enables you to
specify the port on which you're running your backend server, and
Lineman will automatically proxy requests that it doesn't handle
itself to the specified port.  Real simple and very powerful.