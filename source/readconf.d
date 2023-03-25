module readconf;

import std.stdio, std.conv, std.path, std.file;
import core.stdc.stdlib : exit;
import std.regex;
import std.meta;
import singlog;

/** 
 * Read config object
 */
alias rc = Config.file;

class Config
{
private:
    static Config config;
    string path;
    ConfigSection[string] sections;
    bool readed = false;
    const string pattern = "^( |\\t)*(((\\w(\\w|-)+)(( |\\t)*(=>|=){1}"
        ~ "( |\\t)*)(?!\\/(\\/|\\*))(([^ >\"'=\\n\\t#;].*?)|(\"(.+)\")"
        ~ "|('(.+)')){1})|(\\[(\\w(\\w|-)+)\\])|(\\[\\]))( |\\t)*"
        ~ "(( |\\t)(#|;|\\/\\/|\\/\\*).*)?$";

    /** 
     * Reading the configuration file
     */
    bool readConfig()
    {
        File configuration;

        try {
            configuration = File(this.path, "r");
        } catch (Exception e) {
            Log.msg.error("Unable to open the configuration file " ~ this.path);
            Log.msg.warning(e);
            return false;
        }

        auto regular = regex(this.pattern, "m");

        // if main section
        string sectionName = "[]";

        while (!configuration.eof())
        {
            string line = configuration.readln();
            auto match = matchFirst(line, regular);
            if (match)
            {
                // if again main section
                if (match[20].length)
                {
                    sectionName = match[20];
                    continue;
                }
                // if other section
                if (match[17].length)
                {
                    sectionName = match[18];
                    continue;
                }
                // values
                int group = 11;
                if (match[group][0] == '\"')
                    group = 14;
                else if (match[group][0] == '\'')
                    group = 16;

                if (sectionName !in this.sections)
                    this.sections[sectionName] = ConfigSection(sectionName);
                
                this.sections[sectionName].add(ConfigParameter(match[4], match[group]));
            }
        }

        try {
            configuration.close();
            this.readed = true;
        } catch (Exception e) {
            Log.msg.error("Unable to close the configuration file " ~ this.path);
            Log.msg.warning(e);
            this.readed = false;
        }

        return this.readed;
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
    bool read(string path)
    {
        this.path = path;
        if (!path.exists)
        {
            Log.msg.error("The configuration file does not exist: " ~ path);
            return false;
        }

        return readConfig();
    }

    /** 
     * Get the section
     * Params:
     *   section = section name (default main "[]")
     */
    @property ConfigSection sectionName(string section = "[]")
    {
        return section in sections ? sections[section] : ConfigSection();
    }

     /** 
     * Section name
     *
     * Get the section
     * Params:
     *   section = section name (default main "[]")
     */
    alias sn = sectionName;
}

struct ConfigSection
{
    private string name = "[]";
    private ConfigParameter[string] parameters;

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
    ConfigParameter key(string key)
    {
        return key in this.parameters ? this.parameters[key] : ConfigParameter();
    }

    /** 
     * Get all keys and their values
     * Returns: collection of properties structures PP
     */
    ConfigParameter[string] keys()
    {
        return this.parameters;
    }

    private void add(ConfigParameter parameter)
    {
        if (parameter.property in parameters)
            Log.msg.warning("The parameter exists but will be overwritten");
        this.parameters[parameter.property] = parameter;
    }
}

/** 
 * Parameter and its value with the ability to convert to the desired data type
 */
struct ConfigParameter
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
