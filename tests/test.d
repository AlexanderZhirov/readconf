import readconf;
import std.conv;

unittest
{
    rc.read("./tests/settings.conf", "old");
    rc.read("./tests/database.conf", "pgconf");

    assert(rc.cf("old").sn.key("value1") == "text without quotes");
    assert(rc.cf("old").sn.key("value2") == "Yes!");
    assert(rc.cf("old").sn.key("value3") == "value in apostrophes");
    assert(rc.cf("old").sn.key("value4") == "1000");
    assert(rc.cf("old").sn.key("value5") == "0.000");
    assert(rc.cf("old").sn.key("value7") == "//path");
    assert(rc.cf("old").sn.key("value8") == "\"Hey!\"");
    assert(rc.cf("old").sn("part2").key("value1") == "this value will be in the new section");
    assert(rc.cf("old").sn("part2").key("value3") == "good value!");
    assert(rc.cf("old").sn("part3").key("value1") == "-2");
    assert(rc.cf("old").sn("part3").key("value3") == "100");

    auto pgconf = rc.cf("pgconf").sn("postgres");

    assert(pgconf.key("host")        == "//myhost");
    assert(pgconf.key("port").to!int == 5432);
    assert(pgconf.key("name")        == "mydatabase");
    assert(pgconf.key("password")    == "/&#BD&@MXLE");

    auto pgconf2 = rc.cf("pgconf");
    
    assert(pgconf2.sn.key("host")        == "//myhost");
    assert(pgconf2.sn.key("port").to!int == 5432);
    assert(pgconf2.sn.key("name")        == "mydatabase");
    assert(pgconf2.sn.key("password")    == "/&#BD&@MXLE");
}

// void main()
// {
//     import std.stdio;
//     rc.read("./tests/settings.conf");

//     foreach (key, param; rc.sn.keys())
//         writefln("%s => %s", key, param);

//     writeln(rc.sn.key("value1"));

//     foreach (key, param; rc.sn("part2").keys())
//         writefln("%s => %s", key, param);

//     writeln(rc.sn("part2").key("value1"));
// }
