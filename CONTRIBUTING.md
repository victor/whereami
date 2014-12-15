How to contribute
=================

If you feel like contributing to whereas, here’s how.

First of all, fork this repo and clone the fork to your local machine:

```console
$ git clone git@github.com:your-username/whereami.git
```

Make sure you can build the project. There’s no tests (yet). Either build from the command line or from Xcode

```console
$ xctool build
```

Make your changes, and commit them. Push to your fork, and from there submit a pull request.

TODO
====

* Set a timeout for CoreLocation to fail. Sometimes it gets stuck for lack of permission (without requesting it) and then it never returns.
* Write a proper man page.
* Add more options for output of additional data, like altitude, precision or course, and also for input of minimum precision
