# readconf

Singleton for reading the configuration file required for your program.

The `settings.conf` file:

```conf
Such a line will not be read
value1     = This is the full value
value2     = "Take the value in quotation marks"
value3     = 'Or take in apostrophes'
value4     => You can also comment         // Another separator and comment
value5     => 'So you can also comment'    # Yeah!
value6     => 'And you can even do that!'  ; He-he;)
value7     = 1234567890                    # decimal value
value8     => 12345.67890                  ; float value
value9     =>           You can use large margins
value10    =           // But a line without a value will not be read
value11    = //path                        # not working
value12    = "//path"                      // nice way (or '//path')
```

Read `settings.conf` file:

```d
import readconf;
import std.stdio;

void main()
{
    Config.file.read("./settings.conf");

    foreach (key, param; Config.file.keys())
        writefln("%s => %s", key, param);
    
    int val7Int     = Config.file.key("value7").toInt;
    float val8Float = Config.file.key("value8").toFloat;
    // Return default value as 0
    int val8Int     = Config.file.key("value8").toInt;
    float val5Float = Config.file.key("value9").toFloat;

    writefln(
        "val7Int = %s; val8Float = %s; val8Int = %s; val5Float = %s;",
        val7Int, val8Float, val8Int, val5Float
    );
}
```

Result:

![matches.png](img/matches.png)

```
value1 => This is the full value
value2 => Take the value in quotation marks
value3 => Or take in apostrophes
value4 => You can also comment
value5 => So you can also comment
value6 => And you can even do that!
value7 => 1234567890
value8 => 12345.67890
value9 => You can use large margins
value12 => //path
val7Int = 1234567890; val8Float = 12345.7; val8Int = 0; val5Float = 0;
```
