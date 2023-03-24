import readconf;

unittest
{
    Config.file.read("./tests/settings.conf");

    assert(Config.file.key("value1") == "This is the full value");
    assert(Config.file.key("value2") == "Take the value in quotation marks");
    assert(Config.file.key("value3") == "Or take in apostrophes");
    assert(Config.file.key("value4") == "You can also comment");
    assert(Config.file.key("value5") == "So you can also comment");
    assert(Config.file.key("value6") == "\"And you can even do that!\"");
    assert(Config.file.key("value7") == "1234567890");
    assert(Config.file.key("value8") == "12345.67890");
    assert(Config.file.key("value9") == "You can use large margins");
    assert(Config.file.key("value10").empty);
    assert(Config.file.key("value11").empty);
    assert(Config.file.key("value12") == "//path");
}


// void main()
// {
//     import std.stdio;
//     Config.file.read("./tests/settings.conf");

//     foreach (key, param; Config.file.keys())
//         writefln("%s => %s", key, param);

//     writeln(Config.file.key("value1"));
// }
