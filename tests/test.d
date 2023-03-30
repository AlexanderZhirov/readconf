import readconf;
import std.conv;

unittest
{
    rc.read("./examples/simple.conf");

    auto configFile  = rc.cf;
    auto mainSection = configFile.sn;

    assert(mainSection.key("parameter1") == "value1");
    assert(mainSection["parameter2"] == "value2");
    assert(mainSection.key("parameter3") == "value3");
    assert(mainSection["parameter4"] == "value4");
    assert(mainSection.key("_parameter5") == "value5");
    assert(mainSection["parameter6"] == "value6");
    assert(mainSection.key("parameter7") == "value7");
    assert(mainSection["parameter8"] == "value8");
    assert(mainSection.key("parameter9") == "value9");
    assert(mainSection["parameter-10"] == "value10");
    assert(mainSection.key("parameter11") == "value11");
    assert(mainSection["parameter12_"] == "value12");
}

unittest
{
    rc.read("./examples/sections.conf");
    auto configFile  = rc.cf;

    auto mainSection   = configFile.sn;
    auto firstSection  = configFile.sn("first-section");
    auto secondSection = configFile["second-section"];
    auto section       = configFile["_section"];

    assert(mainSection.key("parameter1") == "value8");
    assert(mainSection["parameter_2"] == "value2");
    assert(mainSection["parameter3"] == "value7");

    assert(firstSection["parameter1"] == "value3");
    assert(firstSection["parameter_2"] == "value4");
    assert(firstSection["parameter3"] == "value9");
    assert(firstSection["parameter4"] == "value10");

    assert(secondSection["parameter1"] == "value5");
    assert(secondSection["parameter_2"] == "value6");

    assert(section["parameter1"] == "value11");
    assert(section["parameter2"] == "value12");
}

unittest
{
    rc.read("./examples/simple.conf", "simple");
    rc.read("./examples/sections.conf");
    rc.read("./examples/comments.conf", "comments");

    auto simpleConfig   = rc.cf("simple");
    auto sectionsConfig = rc["sections.conf"];
    auto commentsConfig  = rc["comments"];

    auto simConMaiSec = simpleConfig.sn;

    assert(simConMaiSec.key("parameter1") == "value1");
    assert(simConMaiSec["parameter2"] == "value2");
    assert(simConMaiSec.key("parameter3") == "value3");
    assert(simConMaiSec["parameter4"] == "value4");
    assert(simConMaiSec.key("_parameter5") == "value5");
    assert(simConMaiSec["parameter6"] == "value6");
    assert(simConMaiSec.key("parameter7") == "value7");
    assert(simConMaiSec["parameter8"] == "value8");
    assert(simConMaiSec.key("parameter9") == "value9");
    assert(simConMaiSec["parameter-10"] == "value10");
    assert(simConMaiSec.key("parameter11") == "value11");
    assert(simConMaiSec["parameter12_"] == "value12");

    auto secConMaiSec = sectionsConfig.sn;
    auto secConFirSec = sectionsConfig.sn("first-section");
    auto secConSecSec = sectionsConfig["second-section"];
    auto secConSec    = sectionsConfig["_section"];

    assert(secConMaiSec.key("parameter1") == "value8");
    assert(secConMaiSec["parameter_2"] == "value2");
    assert(secConMaiSec["parameter3"] == "value7");
    assert(secConFirSec["parameter1"] == "value3");
    assert(secConFirSec["parameter_2"] == "value4");
    assert(secConFirSec["parameter3"] == "value9");
    assert(secConFirSec["parameter4"] == "value10");
    assert(secConSecSec["parameter1"] == "value5");
    assert(secConSecSec["parameter_2"] == "value6");
    assert(secConSec["parameter1"] == "value11");
    assert(secConSec["parameter2"] == "value12");

    auto comConMaiSec = commentsConfig.sn;

    assert(comConMaiSec["parameter1"] == "value1");
    assert(comConMaiSec["parameter2"] == "value2");
    assert(comConMaiSec["parameter3"] == "value3");
    assert(comConMaiSec["parameter4"] == "value4");
    assert(comConMaiSec["parameter5"] == "value5;This will not be a comment");
    assert(comConMaiSec["parameter6"] == "value6// This will also be a whole value");
    assert(comConMaiSec["parameter8"] == "//value8");
    assert(comConMaiSec["parameter9"] == ";value9");
    assert(comConMaiSec["parameter10"] == "\"value10\"");
}

unittest
{
    rc.read("./tests/settings.conf");

    assert(rc.cf.sn.key("value1") == "text without quotes");
    assert(rc[][]["value2"] == "Yes!");
    assert(rc.cf.sn.key("value3") == "value in apostrophes");
    assert(rc[][]["value4"] == "1000");
    assert(rc.cf.sn["value5"] == "0.000");
    assert(rc[][].key("value7") == "//path");
    assert(rc.cf.sn.key("value8") == "\"Hey!\"");
    assert(rc[]["part2"]["value1"] == "this value will be in the new section");
    assert(rc.cf.sn("part2").key("value3") == "good value!");
    assert(rc[].sn("part3").key("value1") == "-2");
    assert(rc.cf["part3"]["value3"] == "100");
}
