import readconf;

unittest
{
    rc.read("./tests/settings.conf");
    rc.read("./tests/settings.conf", "new");

    assert(rc.cf("settings.conf").sn.key("value1") == "text without quotes");
    assert(rc.cf("settings.conf").sn.key("value2") == "Yes!");
    assert(rc.cf("settings.conf").sn.key("value3") == "value in apostrophes");
    assert(rc.cf("settings.conf").sn.key("value4") == "1000");
    assert(rc.cf("settings.conf").sn.key("value5") == "0.000");
    assert(rc.cf("settings.conf").sn.key("value7") == "//path");
    assert(rc.cf("settings.conf").sn.key("value8") == "\"Hey!\"");
    assert(rc.cf("settings.conf").sn("part2").key("value1") == "this value will be in the new section");
    assert(rc.cf("settings.conf").sn("part2").key("value3") == "good value!");
    assert(rc.cf("settings.conf").sn("part3").key("value1") == "-2");
    assert(rc.cf("settings.conf").sn("part3").key("value3") == "100");

    assert(rc.cf("new").sn("part3").key("value3") == "100");
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
