class PysonValue
    def initialize(name, value)
        @type = "any"; @name = name; @value = value
    end
    def call 
        return "#{@name}:#{@type}:#{@value}" 
    end
    def toString() 
        String(@value)
    end
end

class PysonValue::PysonInteger < PysonValue
    def initialize(name, value)
        super
        @type = "int"
    end
    def toInt()
        Integer(@value)
    end
end

class PysonValue::PysonString < PysonValue
    def initialize(name, value)
        super
        @type = "str"
    end
end

class PysonValue::PysonArray < PysonValue
    def initialize(name, value)
        super
        @type = "list"
    end
    def toArray()
        temp = @value.split("(*)").join(', ')
    end
end

class PysonValue::PysonFloat < PysonValue
    def initialize(name, value)
        super
        @type = "float"
    end
    def toFloat()
        Float(@value)
    end
    def toInt()
        Integer(@value)
    end
end

def readPysonFile(filename)
    output = []
    file = File.open(filename, "r")
    splitted = file.read().split("\n")
    for i in splitted 
        line = i.split(":")
        case line[1]
            when "str"
                puts PysonValue::PysonString.new(line[0], line[2]).toString()
            when "int"
                puts PysonValue::PysonInteger.new(line[0], line[2]).toInt()
            when "list"
                puts PysonValue::PysonArray.new(line[0], line[2]).toArray()
            when "float"
                puts PysonValue::PysonFloat.new(line[0], line[2]).toFloat()
            else
                puts "You gave me #{line[1]} -- I have no idea what to do with that."
        end 
    end 
end

def writePysonfile(filename, data)
    file = File.open(filename, "w"); 
    output = "" 
    for i in data
        output += (i.call + "\n")
    end
    file.write(output)
end
readPysonFile("example.pyson")
writePysonfile("example2.pyson", [
        PysonValue::PysonString.new("name", "Eli"),
        PysonValue::PysonInteger.new("age", 42),
        PysonValue::PysonArray.new("friends", "Liam(*)Josh"),
        PysonValue::PysonFloat.new("pi", 3.1415962),
    ])