So what is it?
==============

whereami is a simple command-line utility that outputs your geographical coordinates, as determined by Core Location, which uses nearby WiFi networks with known positions to pinpoint your location. It prints them to the standard output in an easy to parse format, in good UNIX fashion.


Requirements
============

whereami only works in versions of Mac OS X 10.6 (Snow Leopard) or greater, as it makes use of the Core Location framework.


Installation and Use
====================

See the notes on [contributing](CONTRIBUTING.md).


TODO
====

* Write a proper man page. There is a template generated by Xcode but I won't commit it just yet
* Add more options for output of additional data, like altitude, precision or course, and also for input of minimum precision
* Write a Makefile so that Xcode is not needed
* Handle errors gracefully. I just need to implement the proper delegate method
* Update CONTRIBUTING with styleguide, layout, and workflow


LICENSE
=======

This code is released under the MIT license. Check the file LICENSE for details.