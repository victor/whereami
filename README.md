[![Build Status](https://travis-ci.org/victor/whereami.svg?branch=swift)](https://travis-ci.org/victor/whereami)

So what is it?
==============

`whereami` is a simple command-line utility that outputs your geographical coordinates, as determined by Core Location, which uses nearby WiFi networks with known positions to pinpoint your location. It prints them to the standard output in an easy to parse format, in good UNIX fashion.


Requirements
============

This version of `whereami` only works in versions of Mac OS X 10.9 (Mavericks) or greater; as it is implemented in Swift. Why in Swift? Well, mostly because the command-line parsing libraries I could find in Objective-C where either a nuisance to install (because of lack of CocoaPods support) or required a lot of code to configure the options I need. On the other hand, [SwiftCLI](https://github.com/jakeheis/SwiftCLI/blob/master/LICENSE) makes it really easy.

To build it, you will require Xcode 6.1 and optionally `xctool`. You can build it from the command line using either `xcodebuild` or `xctool`, whichever you like best. Both should work equally well, but `xctool`’s output is fancier. You can install `xctool` using [homebrew](http://brew.sh).

INSTALLATION
============

`whereami` comes with batteries included. You just need to clone the project to your local machine, switch to the **swift** branch, init the submodules, and install it using `xcodebuild`/`xctool`. In the near future, I will make that branch the main one, but not just yet.

```console
$ git clone https://github.com/victor/whereami.git whereami
$ cd whereami
$ git checkout swift
$ git submodule update --init --recursive
$ xctool install
```

USAGE
=====

Once `whereami` is installed, you can just invoke it to output your location:

```console
$ whereami
41.386905825791,2.14425782089087
```

This is the default format, the tersest. You can also make it output JSON:

```console
$ whereami --format json
{"latitude":41.386905825791, "longitude": 2.14425782089087}
```

Or even output in sexagesimal form:

```console
$ whereami --format sexagesimal
41° 23′ 12.8609728477426″, 2° 8′ 39.3281552071449″
```

Apart from these options, the standard `--version` and `--help` options are recognized.


CONTRIBUTING
============

Please see CONTRIBUTING.md for details.

LICENSE
=======

This code is released under the MIT license. Check the file [LICENSE](LICENSE) for details.
