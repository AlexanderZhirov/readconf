module readconf;

import std.stdio, std.conv, std.path, std.file;
import core.stdc.stdlib : exit;
import std.regex;
import std.meta;
import singlog;

class Config
{
private:
    static Config config;
    string path;
    Partition[string] partitions;
    bool readed = false;
    const string pattern = "^( |\\t)*(((\\w(\\w|-)+)(( |\\t)*(=>|=){1}"
        ~ "( |\\t)*)(?!\\/(\\/|\\*))(([^ >\"'=\\n\\t#;].*?)|(\"(.+)\")"
        ~ "|('(.+)')){1})|(\\[(\\w(\\w|-)+)\\])|(\\[()\\]))( |\\t)*"
        ~ "(( |\\t)(#|;|\\/\\/|\\/\\*).*)?$";

    /** 
     * Reading the configuration file
     */
    void readConfig()
    {
        File configuration;

        try {
            configuration = File(this.path, "r");
        } catch (Exception e) {
            Log.msg.error("Unable to open the configuration file " ~ this.path);
            Log.msg.warning(e);
            return;
        }

        auto regular = regex(this.pattern, "m");

        while (!configuration.eof())
        {
            string line = configuration.readln();
            auto match = matchFirst(line, regular);
            if (match)
            {
                int group = 5;
                if (match[group].length)
                {
                    if (match[group][0] == '\'')
                        group = 10;
                    else if (match[group][0] == '\"')
                        group = 8;
                }
                this.properties[match[1]] = PP(match[1], match[group]);
            }                
        }

        try {
            configuration.close();
            this.readed = true;
        } catch (Exception e) {
            Log.msg.error("Unable to close the configuration file " ~ this.path);
            Log.msg.warning(e);
            return;
        }
    }

    this() {}

public:
    /** 
     * Accessing the Config object
     * Returns: Config Object
     */
    @property static Config file()
    {
        if (this.config is null)
            this.config = new Config;

        return this.config;
    }

    /** 
     * Read the configuration file
     * Params:
     *   path = the path to the configuration file
     */
    void read(string path)
    {
        this.path = path;
        if (!path.exists)
        {
            Log.msg.error("The configuration file does not exist: " ~ path);
            return;
        }
        readConfig();
    }

    Partition part(string partishion = "")
    {

    }
}

/** 
 * Parameter and its value with the ability to convert to the desired data type
 */
struct Parameter
{
    private string property;
    private string value;

    /** 
     * Checking for the presence of a parameter
     * Returns: true if the parameter is missing, otherwise false
     */
    @property bool empty()
    {
        return this.property.length == 0 || this.value.length == 0;
    }

    /** 
     * Get a string representation of the value
     * Returns: default string value
     */
    @property string toString() const
    {
        return this.value;
    }

    alias toString this;

    auto opCast(T)() const
    {
        try {
            return this.value.to!T;
        } catch (Exception e) {
            Log.msg.error("Cannot convert type");
            Log.msg.warning(e);
            return T.init;
        }            
    }
}

struct Partition
{
    private string name = "[]";
    private Parameter[string] parameters;

    /** 
     * Checking for the presence of a partition
     * Returns: true if the parameter is missing, otherwise false
     */
    @property bool empty()
    {
        return this.parameters.length == 0;
    }

    /** 
     * Get the parameter value
     * Params:
     *   key = parameter from the configuration file
     * Returns: the value of the parameter in the PP structure view
     */
    Parameter key(string key)
    {
        return key in this.parameters ? this.parameters[key] : Parameter();
    }

    /** 
     * Get all keys and their values
     * Returns: collection of properties structures PP
     */
    Parameter[string] keys()
    {
        return this.parameters;
    }

    bool add(Parameter parameter)
    {

    }
}
