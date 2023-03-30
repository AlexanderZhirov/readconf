<p align="center">
    <img src="img/logo.png" width=320>
</p>

<h1 align="center">readconf</h1>

[![license](https://img.shields.io/github/license/AlexanderZhirov/readconf.svg?sort=semver&style=for-the-badge&color=green)](https://www.gnu.org/licenses/old-licenses/gpl-2.0.html)
[![main](https://img.shields.io/badge/dynamic/json.svg?label=git.zhirov.kz&style=for-the-badge&url=https://git.zhirov.kz/api/v1/repos/dlang/readconf/tags&query=$[0].name&color=violet&logo=D)](https://git.zhirov.kz/dlang/readconf)
[![githab](https://img.shields.io/github/v/tag/AlexanderZhirov/readconf.svg?sort=semver&style=for-the-badge&color=blue&label=github&logo=D)](https://github.com/AlexanderZhirov/readconf)
[![dub](https://img.shields.io/dub/v/readconf.svg?sort=semver&style=for-the-badge&color=orange&logo=D)](https://code.dlang.org/packages/readconf)
[![linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)](https://www.linux.org/)

Singleton for reading the configuration file required for your program.

## What can do

- Reading multiple configuration files
- Separation of parameters by sections
- Access to parameters and sections using keys and indexes
- Commenting on lines

You will get more detailed information on the [wiki](https://git.zhirov.kz/dlang/readconf/wiki).

## Quick start

The `settings.conf` file (see the [tests](tests/)):

![matches.png](img/matches.png)

Read `settings.conf` file:

```d
import readconf;
import std.stdio;

void main()
{
    rc.read("./tests/settings.conf");

    foreach (key, param; rc.sn.keys())
        writefln("%s => %s", key, param);

    writeln(rc.sn.key("value1"));

    foreach (key, param; rc.sn("part2").keys())
        writefln("%s => %s", key, param);

    writeln(rc["part2"]["value1"]);
}
```

Result:

```
value1 => text without quotes
value2 => Yes!
value3 => value in apostrophes
value4 => 1000
value5 => 0.000
value7 => //path
value8 => "Hey!"
text without quotes
value1 => this value will be in the new section
value3 => good value!
this value will be in the new section
```

## Unittests

The unittests provide [examples](examples/) of configuration files and the `settings.conf` file located in the [tests](tests/):

```sh
Running bin/readconf-test-unittest 
 ✓ test __unittest_L4_C1
 ✓ test __unittest_L106_C1
 ✓ test __unittest_L25_C1
 ✓ test __unittest_L51_C1

Summary: 4 passed, 0 failed in 7 ms
```

## DUB

Add a dependency on `"readconf": "~>0.3.0"`
