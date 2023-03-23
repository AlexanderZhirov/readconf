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
    PP[string] properties;
    bool readed = false;

    /** 
     * Parameter and its value with the ability to convert to the desired data type
     */
    struct PP
    {
        private string property;
        private string value;

        /** 
         * Checking for the presence of a parameter
         * Returns: true if the parameter is missing, otherwise false
         */
        @property bool empty()
        {
            return this.property.length = 0;
        }

        /** 
         * Get an integer value
         * Returns: integer value or 0 if missing
         */
        @property int toInt() const
        {
            try {
                return to!int(this.value);
            } catch (Exception) {
                Log.msg.warning("Failed to convert parameter to integer type: " ~ this.property);
                return 0;
            }
        }

        /** 
         * Get a floating point value
         * Returns: floating point value or 0.0 if missing
         */
        @property float toFloat() const
        {
            try {
                return to!float(this.value);
            } catch (Exception) {
                Log.msg.warning("Failed to convert parameter to float type: " ~ this.property);
                return 0.0;
            }
        }

        /** 
         * Get a string representation of the value
         * Returns: default string value
         */
        @property string toString() const
        {
            return value;
        }

        alias toString this;
    }

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

        string pattern = "^ *(\\w+)(( +=> +)|( += +))(?!\\/\\/)(([^ >\"'\\n#;].*?)|
            (\"(.+?)\")|('(.+?)')){1} *( #.*?)?( ;.*?)?( \\/\\/.*)?$";
        auto regular = regex(pattern, "m");

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
                    if (match[group][0] == '\"')
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

    /** 
     * Get the parameter value
     * Params:
     *   key = parameter from the configuration file
     * Returns: the value of the parameter in the PP structure view
     */
    PP key(string key)
    {
        if (this.readed)
            return key in this.properties ? this.properties[key] : PP();
        Log.msg.warning("The configuration file was not read!");
        return PP();
    }

    /** 
     * Get all keys and their values
     * Returns: collection of properties structures PP
     */
    PP[string] keys()
    {
        return this.properties;
    }
}
