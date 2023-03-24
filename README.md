# readconf

Singleton for reading the configuration file required for your program.

## Quick start

The `settings.conf` file (see the [tests](tests/)):

![matches.png](img/matches.png)

Read `settings.conf` file:

```d
import readconf;
import std.stdio;

void main()
{
    Config.file.read("./settings.conf");

    foreach (key, param; Config.file.keys())
        writefln("%s => %s", key, param);

    writeln(Config.file.key("value1"));
}
```

Result:

```
value1 => This is the full value
value2 => Take the value in quotation marks
value3 => Or take in apostrophes
value4 => You can also comment
value5 => So you can also comment
value6 => "And you can even do that!"
value7 => 1234567890
value8 => 12345.67890
value9 => You can use large margins
value12 => //path
This is the full value
```
