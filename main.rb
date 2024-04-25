# Pyson implementation in Ruby
# PysonValue is a default implementation of PysonValue interface, kind of a base
class PysonValue
    def initialize(name, value)
        if not defined?(@type)
            raise "Stop using the any type"
        end
        #@type = "any"
        @name = name
        @value = value
    end
    def call 
        return "#{@name}:#{@type}:#{@value}" 
    end
    def toString() 
        String(@value)
    end
end
# PysonInteger is the implementation of PysonValue interface for integer
class PysonValue::PysonInteger < PysonValue
    def initialize(name, value)
        @type = "int"
        super
    end
    def toInt()
        Integer(@value)
    end
end
# PysonString is the implementation of PysonValue interface for string
class PysonValue::PysonString < PysonValue
    def initialize(name, value)
        @type = "str"
        super
    end
end
# PysonArray is the implementation of PysonValue interface for thet array (list) type
# the thing however is that the array is really just a list of strings
# there really can't really be an array of integers, or floats, just because how Liam's
# implementation works
class PysonValue::PysonArray < PysonValue
    def initialize(name, value)
        @type = "list"
        super
    end
    def toArray()
        temp = @value.split("(*)").join(', ')
    end
end
# PysonFloat is the implementation of PysonValue interface for the float type
class PysonValue::PysonFloat < PysonValue
    def initialize(name, value)
        @type = "float"
        super
    end
    def toFloat()
        Float(@value)
    end
    def toInt()
        Integer(@value)
    end
end
# readPysonFile is the function that reads the .pyson file and returns the PysonValue object
# this implementation of readPysonFile is pretty lax, it just ignores extra non-pyson text and data
# this allows you to add comments to your .pyson file, but it's not really meant to be used
def readPysonFile(filename)
    output = []
    file = File.open(filename, "r")
    splitted = file.read().split("\n")
    for i in splitted 
        line = i.split(":")
        temp = ""
        case line[1]
            when "str"
                temp = PysonValue::PysonString.new(line[0], line[2]).toString()
            when "int"
                temp = PysonValue::PysonInteger.new(line[0], line[2]).toInt()
            when "list"
                temp = PysonValue::PysonArray.new(line[0], line[2]).toArray()
            when "float"
                temp = PysonValue::PysonFloat.new(line[0], line[2]).toFloat()
            # Any type? more like STRING
            when "any"
                warn "Warning: Please stop using the any type guys"
                temp = PysonValue.new(line[0], line[2]).toString()
            else
                puts "You gave me #{line[1]} -- I have no idea what to do with that."
        end
        puts temp
        output.push(temp)
    end
    return output
end


# couldn't you getwhole and split???
def getData(filePath, dataName)
    """Inputs: 
    filePath - folder/file.pyson (note: can have multiple folder paths, however file MUST use pyson-type file configuration.
    datacall: str - name of data that you are extracting
    Outputs the data stored in pyson format that it's inserted as."""
    
    
    found = nil
    foundType = nil
    for item in File.open(filePath, "r").read().split("\n")
        splitted = item.split(":")
        if splitted[0] == dataName
            found = splitted[2]
            foundType = splitted[1]
            break
        end
    end

    if found.nil?
        raise "Data At Value #{dataName} Not Found. Maybe try a different file?"
    end
        
    case foundType
        when "str"
            return String(found)
        when "int"
            return Integer(found)
        when "float"
            return Float(found)
        when "list"
            return found.split("(*)")
        else
            puts "You gave me #{line[1]} -- I have no idea what to do with that."
    end
end

# writes pyson data to a pyson file. data is a list of PysonValue objects
# the program "calls" each object (slow, I know) but it makes it easier to maintain
def writePysonfile(filename, data)
    file = File.open(filename, "w")
    output = "" 
    for i in data
        output += (i.call + "\n")
    end
    file.write(output)
end

def verifyFile(filename)
    """Checks if the file is a pyson file. Returns true if it is, false if it isn't"""
    # TODO: add more checks
    file = File.open(filename, "r").read().split("\n")
    
    # check for duplications
    if duplications(file)
        raise "Duplicate Data has been Found in #{filename}"
    end
    # check for invalid types
    for i in file
        if i.split(":").length() != 3
            raise "Invalid formatting, Expected 3 parts, name:type:value but got #{i}"
        case i.split(":")[1]
            when not ("str" or "int" or "float" or "list")
                raise "Invalid type #{i} at line #{file.index(i)} in #{filename}"
        end
    end
end

# o(n) list filtering algo (better than naive o(n^2))
def duplications(list)
    result = []
    hash_table = {}
    list.each do |item|
        return true if hash_table[item]
        hash_table[item] = true
    end
    return false
end
# examples for writing and reading pyson files

readPysonFile("example.pyson")
# writePysonfile("example.pyson", [
#         PysonValue::PysonString.new("name", "Eli"),
#         PysonValue::PysonInteger.new("age", 42),
#         PysonValue::PysonArray.new("friends", "Liam(*)Josh"),
#         PysonValue::PysonFloat.new("pi", 3.1415962),
#         # dont use this
#         #PysonValue.new("Any type", "should be deprecated")
#     ]
# )
puts getData("example.pyson", "name")