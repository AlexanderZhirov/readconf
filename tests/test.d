import readconf;

unittest
{
    rc.read("./tests/settings.conf");

    assert(rc.sn.key("value1") == "This is the full value");
    assert(rc.sn.key("value2") == "Take the value in quotation marks");
    assert(rc.sn.key("value3") == "Or take in apostrophes");
    assert(rc.sn.key("value4") == "You can also comment");
    assert(rc.sn.key("value5") == "So you can also comment");
    assert(rc.sn.key("value6") == "\"And you can even do that!\"");
    assert(rc.sn.key("value7") == "1234567890");
    assert(rc.sn.key("value8") == "12345.67890");
    assert(rc.sn.key("value9") == "You can use large margins");
    assert(rc.sn.key("value10").empty);
    assert(rc.sn.key("value11").empty);
    assert(rc.sn.key("value12") == "//path");
}


// void main()
// {
//     import std.stdio;
//     Config.file.read("./tests/settings.conf");

//     foreach (key, param; Config.file.keys())
//         writefln("%s => %s", key, param);

//     writeln(Config.file.key("value1"));
// }
