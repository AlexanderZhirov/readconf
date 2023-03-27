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

private const string mainSection = "[]";

class Config
{
private:
    enum {
        GROUP_PROPERTY            = 4,
        GROUP_VALUE_1             = 11, // string
        GROUP_VALUE_2             = 14, // "strin"
        GROUP_VALUE_3             = 16, // 'string'
        GROUP_SECTION_OTHER_OUTER = 17, // "[string]"
        GROUP_SECTION_OTHER_INNER = 18, // "[string]"
        GROUP_SECTION_MAIN        = 20, // "[]"
    }

    static Config config;
    string path;
    bool readed = false;
    ConfigFile[string] configs;

    const string pattern = "^( |\\t)*(((\\w(\\w|-)+)(( |\\t)*(=>|=){1}"
        ~ "( |\\t)*)(?!\\/(\\/|\\*))(([^ >\"'=\\n\\t#;].*?)|(\"(.+)\")"
        ~ "|('(.+)')){1})|(\\[(\\w(\\w|-)+)\\])|(\\[\\]))( |\\t)*"
        ~ "(( |\\t)(#|;|\\/\\/|\\/\\*).*)?$";

    /** 
     * Reading the configuration file
     */
    bool readConfig(const string configName)
    {
        File configuration;

        try {
            configuration = File(this.path, "r");
        } catch (Exception e) {
            Log.msg.warning("Unable to open the configuration file " ~ this.path);
            Log.msg.error(e);
            return false;
        }

        if (configName !in this.configs)
            this.configs[configName] = ConfigFile(configName);

        auto regular = regex(this.pattern, "m");

        // reading from the main section
        string sectionName = mainSection;

        while (!configuration.eof())
        {
            string line = configuration.readln();
            auto match = matchFirst(line, regular);
            if (match)
            {
                // if again main section
                if (match[GROUP_SECTION_MAIN].length)
                {
                    sectionName = match[GROUP_SECTION_MAIN];
                    continue;
                }
                if (match[GROUP_SECTION_OTHER_OUTER].length)
                {
                    sectionName = match[GROUP_SECTION_OTHER_INNER];
                    continue;
                }

                int group = GROUP_VALUE_1;

                if (match[group][0] == '\"')
                    group = GROUP_VALUE_2;
                else if (match[group][0] == '\'')
                    group = GROUP_VALUE_3;

                this.configs[configName].add(sectionName, ConfigParameter(match[GROUP_PROPERTY], match[group]));
                    
                // if (sectionName !in this.sections)
                //     this.sections[sectionName] = ConfigSection(sectionName);
                
                // this.sections[sectionName].add(ConfigParameter(match[GROUP_PROPERTY], match[group]));
            }
        }

        try {
            configuration.close();
            this.readed = true;
        } catch (Exception e) {
            Log.msg.warning("Unable to close the configuration file " ~ this.path);
            Log.msg.error(e);
            this.configs.remove(configName);
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
    bool read(string path, string configName = "")
    {
        this.path = path;
        if (!path.exists)
            throw new Exception("The configuration file does not exist: " ~ path);
        if (configName.length == 0)
            configName = path.baseName();
        if (configName in configs)
            throw new Exception("The configuration file with this name has already been read");
        return readConfig(configName);
    }

    /** 
     * Get the section
     * Params:
     *   section = section name (default main "[]")
     */
    @property ConfigFile configFile(string configName = "")
    {
        if (configName.length == 0)
        {
            if (configs.length == 1)
                return configs[configs.byKey.front];
            else
                throw new Exception("You must explicitly specify the name of the configuration file");
        }

        return configName in configs ? configs[configName] : ConfigFile(configName);
    }

     /** 
     * Config file
     *
     * Get the config file
     * Params:
     *   configName = config name (by default the name of the configuration file)
     */
    alias cf = configFile;
}

struct ConfigFile
{
    private string name;
    private ConfigSection[string] sections;

    @property bool exist()
    {
        return this.sections.length > 0;
    }

    /** 
     * Get the section
     * Params:
     *   section = section name (default main "[]")
     */
    @property ConfigSection sectionName(string section = mainSection)
    {
        if (!this.exist)
            throw new Exception("The configuration file does not exist");
        if (section == mainSection && sections.length == 1)
            return sections[sections.byKey.front];
        return section in sections ? sections[section] : ConfigSection(section);
    }

     /** 
     * Section name
     *
     * Get the section
     * Params:
     *   section = section name (default main "[]")
     */
    alias sn = sectionName;

    private void add(string sectionName, ConfigParameter parameter)
    {
        if (sectionName !in this.sections)
            this.sections[sectionName] = ConfigSection(sectionName);

        this.sections[sectionName].add(parameter);
    }
}

struct ConfigSection
{
    private string name = mainSection;
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
        if (this.empty)
            throw new Exception("The selected section has no parameters or does not exist");
        return key in this.parameters ? this.parameters[key] : ConfigParameter(key);
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
        return this.value.length == 0;
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
            Log.msg.warning("Cannot convert type");
            Log.msg.error(e);
            return T.init;
        }            
    }
}
