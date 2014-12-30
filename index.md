---
---

### What is it, and how to use it

`whereami` is the simplest way to get your location when at the command line. In the simplest form, just invoke the command and it will respond with your location coordinates:

```shell
$ whereami
41.386905825791,2.14425782089087
```

If you need fancier output, you can pass `--format json` or `--format sexagesimal` to get the output in the corresponding format:

```shell
$ whereami --format json
{"latitude":41.386905825791, "longitude": 2.14425782089087}
$ whereami --format sexagesimal
41° 23′ 12.8609728477426″, 2° 8′ 39.3281552071449″
```

### Other options
In addition to the above options, there's also the mandatory `--version` and `--help` options.

### How to get it
The easiest way is with [Homebrew](http://brew.sh).

```shell
$ brew tap victor/whereami && brew install whereami
```

Otherwise, head on to [the repo](https://github.com/victor/whereami) and follow the instructions there.

### Hacking
If you want to get your hands dirty, contributions are welcome. Please check [the github repo](https://github.com/victor/whereami) for details.

### Travis Build Status

[![Build Status](https://travis-ci.org/victor/whereami.svg?branch=swift)](https://travis-ci.org/victor/whereami)
