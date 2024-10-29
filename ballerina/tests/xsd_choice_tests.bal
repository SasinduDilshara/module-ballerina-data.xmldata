import ballerina/test;

type User record {
    @Choice {
        id: "a1"
    }
    string id?;
    @Choice {
        id: "a1"
    }
    string name?;
    @Choice {
        id: "a2"
    }
    int age?;
    @Choice {
        id: "a2"
    }
    string gender?;
};

@test:Config {groups: ["xsd", "xsd_choice"]}
function testXsdChoice1() returns error? {
    string xmlValue = string `<User><id>1</id><age>23</age></User>`;
    User|Error user = check parseString(xmlValue);
    test:assertEquals(user, {id: "1", age: 23});

    xmlValue = string `<User><name>John Doe</name><age>23</age><id>1</id></User>`;
    user = parseString(xmlValue);
    test:assertTrue(user is Error);
    test:assertEquals((<Error>user).message(), "max occurrences exceeded for the choice element 'id'");

    xmlValue = string `<User><name>John Doe</name><age>23</age><id2>1</id2></User>`;
    user = check parseString(xmlValue);
    test:assertEquals(user, {"name": "John Doe", "age": 23, "id2": 1});

    xmlValue = string `<User><id>1</id><name>John Doe</name></User>`;
    user = parseString(xmlValue);
    test:assertTrue(user is Error);
    test:assertEquals((<Error>user).message(), "max occurrences exceeded for the choice element 'name'");

    xmlValue = string `<User><id>1</id></User>`;
    user = parseString(xmlValue);
    test:assertTrue(user is Error);
    test:assertEquals((<Error>user).message(), "min occurrences does not reach for the choice element 'a2'");
}

type User2 record {
    @Choice {
        id: "a1"
    }
    string id?;
    @Choice {
        id: "a1"
    }
    string name?;
    string group = "group1";
    string address;
    @Choice {
        id: "a2"
    }
    int age?;
    @Choice {
        id: "a2"
    }
    string gender?;
};

@test:Config {groups: ["xsd", "xsd_choice"]}
function testXsdChoice2() returns error? {
    string xmlValue = string `<User><id>1</id><address>Address 1</address><age>23</age></User>`;
    User2|Error user = check parseString(xmlValue);
    test:assertEquals(user, {id: "1", age: 23, address: "Address 1", group: "group1"});

    xmlValue = string `<User><name>John Doe</name><address>Address 1</address><age>23</age><id>1</id></User>`;
    user = parseString(xmlValue);
    test:assertTrue(user is Error);
    test:assertEquals((<Error>user).message(), "max occurrences exceeded for the choice element 'id'");

    xmlValue = string `<User><name>John Doe</name><address>Address 1</address><age>23</age><id2>1</id2></User>`;
    user = check parseString(xmlValue);
    test:assertEquals(user, {"name": "John Doe", "age": 23, "id2": 1, address: "Address 1", group: "group1"});

    xmlValue = string `<User><id>1</id><address>Address 1</address><name>John Doe</name></User>`;
    user = parseString(xmlValue);
    test:assertTrue(user is Error);
    test:assertEquals((<Error>user).message(), "max occurrences exceeded for the choice element 'name'");

    xmlValue = string `<User><id>1</id><address>Address 1</address></User>`;
    user = parseString(xmlValue);
    test:assertTrue(user is Error);
    test:assertEquals((<Error>user).message(), "min occurrences does not reach for the choice element 'a2'");
}

type User3 record {
    @Choice {
        id: "a1"
    }
    string id?;
    @Choice {
        id: "a1"
    }
    string name?;
    @Choice {
        id: "a2"
    }
    int age?;
    @Choice {
        id: "a2"
    }
    string gender?;
    record {
        @Choice {
            id: "a3"
        }
        string id2?;
        @Choice {
            id: "a3"
        }
        string name2?;
        @Choice {
            id: "a4"
        }
        int age2?;
        @Choice {
            id: "a4"
        }
        string gender2?;
    } nestedXml;
};

@test:Config {groups: ["xsd", "xsd_choice"]}
function testXsdChoice3() returns error? {
    string xmlValue = string `<User><id>1</id><age>23</age><nestedXml><id2>1</id2><age2>23</age2></nestedXml></User>`;
    User3|Error user = check parseString(xmlValue);
    test:assertEquals(user, {id: "1", age: 23, nestedXml: {id2: "1", age2: 23}});

    xmlValue = string `<User><name>John Doe</name><nestedXml><id2>1</id2><age2>23</age2></nestedXml><age>23</age><id>1</id></User>`;
    user = parseString(xmlValue);
    test:assertTrue(user is Error);
    test:assertEquals((<Error>user).message(), "max occurrences exceeded for the choice element 'id'");

    xmlValue = string `<User><name>John Doe</name><nestedXml><id2>1</id2><age2>23</age2></nestedXml><age>23</age><id2>1</id2></User>`;
    user = check parseString(xmlValue);
    test:assertEquals(user, {"name": "John Doe", "age": 23, "id2": 1, nestedXml: {id2: "1", age2: 23}});

    xmlValue = string `<User><id>1</id><nestedXml><id2>1</id2><age2>23</age2></nestedXml><name>John Doe</name></User>`;
    user = parseString(xmlValue);
    test:assertTrue(user is Error);
    test:assertEquals((<Error>user).message(), "max occurrences exceeded for the choice element 'name'");

    xmlValue = string `<User><id>1</id><nestedXml><id2>1</id2><age2>23</age2></nestedXml></User>`;
    user = parseString(xmlValue);
    test:assertTrue(user is Error);
    test:assertEquals((<Error>user).message(), "min occurrences does not reach for the choice element 'a2'");
}

type User4 record {
    @Choice {
        id: "a1"
    }
    string id?;
    @Choice {
        id: "a2"
    }
    int age?;
    record {|
        @Choice {
            id: "a3"
        }
        string id2?;
        @Choice {
            id: "a3"
        }
        string name2?;
        @Choice {
            id: "a4"
        }
        int age2?;
        @Choice {
            id: "a4"
        }
        string gender2?;
    |} nestedXml;
    @Choice {
        id: "a1"
    }
    string name?;
    @Choice {
        id: "a2"
    }
    string gender?;
};

@test:Config {groups: ["xsd", "xsd_choice"]}
function testXsdChoice4() returns error? {
    string xmlValue = string `<User><name>John Doe</name><nestedXml><id2>1</id2><age2>23</age2><name2>1</name2></nestedXml><age>23</age></User>`;
    User4|Error user = parseString(xmlValue);
    test:assertTrue(user is Error);
    test:assertEquals((<Error>user).message(), "max occurrences exceeded for the choice element 'name2'");

    xmlValue = string `<User><name>John Doe</name><nestedXml><id2>1</id2><age2>23</age2><id3>1</id3></nestedXml><age>23</age><id2>1</id2></User>`;
    user = check parseString(xmlValue);
    test:assertEquals(user, {"name": "John Doe", "age": 23, "id2": 1, nestedXml: {id2: "1", age2: 23}});

    xmlValue = string `<User><id>1</id><nestedXml><id2>1</id2><name2>John</name2></nestedXml><name>John Doe</name></User>`;
    user = parseString(xmlValue);
    test:assertTrue(user is Error);
    test:assertEquals((<Error>user).message(), "max occurrences exceeded for the choice element 'name2'");

    xmlValue = string `<User><id>1</id><age>23</age><nestedXml><id2>1</id2></nestedXml></User>`;
    user = parseString(xmlValue);
    test:assertTrue(user is Error);
    test:assertEquals((<Error>user).message(), "min occurrences does not reach for the choice element 'a4'");
}

type User5 record {
    @Choice {
        id: "a1"
    }
    string id?;
    @Choice {
        id: "a1"
    }
    string name?;
    string group = "group1";
    string address;
    @Choice {
        id: "a2"
    }
    int age?;
    @Choice {
        id: "a2"
    }
    string gender?;
};

@test:Config {groups: ["xsd", "xsd_choice"]}
function testXsdChoice5() returns error? {
    string xmlValue = string `<User><id>1</id><address>Address 1</address><age>23</age></User>`;
    User5|Error user = check parseString(xmlValue);
    test:assertEquals(user, {id: "1", age: 23, address: "Address 1", group: "group1"});

    xmlValue = string `<User><name>John Doe</name><address>Address 1</address><age>23</age><id>1</id></User>`;
    user = parseString(xmlValue);
    test:assertTrue(user is Error);
    test:assertEquals((<Error>user).message(), "max occurrences exceeded for the choice element 'id'");

    xmlValue = string `<User><name>John Doe</name><address>Address 1</address><age>23</age><id2>1</id2></User>`;
    user = check parseString(xmlValue);
    test:assertEquals(user, {"name": "John Doe", "age": 23, "id2": 1, address: "Address 1", group: "group1"});

    xmlValue = string `<User><id>1</id><address>Address 1</address><name>John Doe</name></User>`;
    user = parseString(xmlValue);
    test:assertTrue(user is Error);
    test:assertEquals((<Error>user).message(), "max occurrences exceeded for the choice element 'name'");

    xmlValue = string `<User><id>1</id><address>Address 1</address></User>`;
    user = parseString(xmlValue);
    test:assertTrue(user is Error);
    test:assertEquals((<Error>user).message(), "min occurrences does not reach for the choice element 'a2'");
}

// Commented due to https://github.com/ballerina-platform/ballerina-library/issues/7310

// type User6 record {
//     @Choice {
//         id: "a1"
//     }
//     string id?;
//     @Choice {
//         id: "a2"
//     }
//     int age?;
//     record {|
//         @Choice {
//             id: "a3"
//         }
//         string id2?;
//         @Choice {
//             id: "a3"
//         }
//         string name2?;
//         @Choice {
//             id: "a4"
//         }
//         int age2?;
//         @Choice {
//             id: "a4"
//         }
//         string gender2?;
//     |} nestedXml;
//     @Choice {
//         id: "a1"
//     }
//     string name?;
//     @Choice {
//         id: "a2"
//     }
//     string gender?;
// };

// @test:Config {groups: ["xsd", "xsd_choice"]}
// function testXsdChoice6() returns error? {
//     string xmlValue = string `<User><id>1</id><age>23</age><nestedXml><id>1</id><age>23</age></nestedXml></User>`;
//     User6|Error user = check parseString(xmlValue);
//     test:assertEquals(user, {id: "1", age: 23, nestedXml: {id: "1", age: 23}});

//     xmlValue = string `<User><name>John Doe</name><nestedXml><id>1</id><age>23</age><name>1</name></nestedXml><age>23</age></User>`;
//     user = parseString(xmlValue);
//     test:assertTrue(user is Error);
//     test:assertEquals((<Error>user).message(), "max occurrences exceeded for the choice element 'name'");

//     xmlValue = string `<User><name>John Doe</name><nestedXml><id>1</id><age>23</age><id3>1</id3></nestedXml><age>23</age><id>1</id></User>`;
//     user = check parseString(xmlValue);
//     test:assertEquals(user, {"name": "John Doe", "age": 23, "id": 1, nestedXml: {id: "1", age: 23}});

//     xmlValue = string `<User><id>1</id><nestedXml><id>1</id><name>John</name></nestedXml><name>John Doe</name></User>`;
//     user = parseString(xmlValue);
//     test:assertTrue(user is Error);
//     test:assertEquals((<Error>user).message(), "max occurrences exceeded for the choice element 'name'");

//     xmlValue = string `<User><id>1</id><age>23</age><nestedXml><id>1</id></nestedXml></User>`;
//     user = parseString(xmlValue);
//     test:assertTrue(user is Error);
//     test:assertEquals((<Error>user).message(), "min occurrences does not reach for the choice element 'a4'");
// }