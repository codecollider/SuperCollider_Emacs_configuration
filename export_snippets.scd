

s.boot

(
var outFile, stream;
var keywords, constants, arguments;
var classes, classMethods, instMethods;

outFile = "~/tmp/sc-syntax-export.txt".standardizePath; 
stream = File(outFile, "w");

// Hardcoded language elements
keywords = ["arg", "var", "if", "while", "for", "case", "do", "return", "this", "super"];
constants = ["nil", "true", "false", "inf"];
arguments = ["freq:", "amp:", "bufnum:", "out:", "dur:", "pan:"];

// Collect classes
classes = Set.new;
Class.allClasses.do { |c|
    classes.add(c.name.asString.replace("Meta_", ""));
};
classes = classes.asArray.sort;

// Collect class methods (defined directly on metaclass)
classMethods = Set.new;
Class.allClasses.do { |c|
    c.class.methods.do { |m|
        if (m.ownerClass == c.class) { classMethods.add(m.name.asString); };
    };
};
classMethods = classMethods.asArray.sort;

// Collect instance methods (defined directly on class)
instMethods = Set.new;
Class.allClasses.do { |c|
    c.methods.do { |m|
        if (m.ownerClass == c) { instMethods.add(m.name.asString); };
    };
};
instMethods = instMethods.asArray.sort;

// Write sections
stream.write("[CLASSES]\n");
classes.do { |name| stream.write(name ++ "\n") };

stream.write("\n[CLASS-METHODS]\n");
classMethods.do { |name| stream.write(name ++ "\n") };

stream.write("\n[INSTANCE-METHODS]\n");
instMethods.do { |name| stream.write(name ++ "\n") };

stream.write("\n[KEYWORDS]\n");
keywords.sort.do { |kw| stream.write(kw ++ "\n") };

stream.write("\n[CONSTANTS]\n");
constants.sort.do { |c| stream.write(c ++ "\n") };

stream.write("\n[ARGUMENTS]\n");
arguments.sort.do { |a| stream.write(a ++ "\n") };

stream.close;
"Exported SuperCollider syntax to %".format(outFile).postln;
)
