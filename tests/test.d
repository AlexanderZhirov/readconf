import readconf;

unittest
{
    rc.read("./tests/settings.conf");

    assert(rc.sn.key("value1") == "text without quotes");
    assert(rc.sn.key("value2") == "Yes!");
    assert(rc.sn.key("value3") == "value in apostrophes");
    assert(rc.sn.key("value4") == "1000");
    assert(rc.sn.key("value5") == "0.000");
    assert(rc.sn.key("value7") == "//path");
    assert(rc.sn.key("value8") == "\"Hey!\"");
    assert(rc.sn("part2").key("value1") == "this value will be in the new section");
    assert(rc.sn("part2").key("value3") == "good value!");
    assert(rc.sn("part3").key("value1") == "-2");
    assert(rc.sn("part3").key("value3") == "100");
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
