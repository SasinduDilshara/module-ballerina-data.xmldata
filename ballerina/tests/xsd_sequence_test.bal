// Copyright (c) 2024, WSO2 LLC. (https://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied. See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/test;

@Name {
    value: "SimpleXSDSequenceRecord"
}
type SimpleXSDSequenceRecord record {
    @Sequence {
        id: "a1",
        sequenceOrder: 1
    }
    string name;
    @Sequence {
        id: "a1",
        sequenceOrder: 2
    }
    int age;
};

@test:Config {groups: ["xsd", "xsd_sequence"]}
function testXMLStringSourceWithXSDSequences() returns error? {
    string validXmlValue = string `<SimpleXSDSequenceRecord><name>John</name><age>30</age></SimpleXSDSequenceRecord>`;
    SimpleXSDSequenceRecord validatedOutput = check parseString(validXmlValue);
    test:assertEquals(validatedOutput, {name: "John", age: 30});

    string invalidXmlValue = string `<SimpleXSDSequenceRecord><age>30</age><name>John</name></SimpleXSDSequenceRecord>`;
    SimpleXSDSequenceRecord|Error validatedOutput2 = parseString(invalidXmlValue);
    test:assertTrue(validatedOutput2 is error);
    test:assertEquals((<error>validatedOutput2).message(), "invalid sequence order for the element 'name'");
}

type SimpleXSDSequenceRecord2 record {
    @Sequence {
        id: "a1",
        sequenceOrder: 1
    }
    string name;
    @Sequence {
        id: "a1",
        sequenceOrder: 2
    }
    int age;

    record {
        @Sequence {
            id: "a2",
            sequenceOrder: 1
        }
        string nestedName;
        @Sequence {
            id: "a2",
            sequenceOrder: 2
        }
        int nestedAge;
    } nestedRecord;

    string taxNumber = "N/A";
};

@test:Config {groups: ["xsd", "xsd_sequence"]}
function testXMLStringSourceWithXSDSequences2() returns error? {
    string validXmlValue = 
        string `<SimpleXSDSequenceRecord><name>John</name><age>30</age><nestedRecord><nestedName>John</nestedName><nestedAge>30</nestedAge></nestedRecord></SimpleXSDSequenceRecord>`;
    SimpleXSDSequenceRecord2 validatedOutput = check parseString(validXmlValue);
    test:assertEquals(validatedOutput, {name: "John", age: 30, nestedRecord: {nestedName: "John", nestedAge: 30}, taxNumber: "N/A"});

    string invalidXmlValue = 
        string `<SimpleXSDSequenceRecord><name>John</name><age>30</age><nestedRecord><nestedAge>30</nestedAge><nestedName>John</nestedName></nestedRecord></SimpleXSDSequenceRecord>`;
    SimpleXSDSequenceRecord2|Error validatedOutput2 = parseString(invalidXmlValue);
    test:assertTrue(validatedOutput2 is error);
    test:assertEquals((<error>validatedOutput2).message(), "invalid sequence order for the element 'nestedName'");
}

type SimpleXSDSequenceRecord3 record {
    @Sequence {
        id: "a1",
        sequenceOrder: 1
    }
    string name;
    @Sequence {
        id: "a1",
        sequenceOrder: 2
    }
    int age;

    record {
        @Sequence {
            id: "a2",
            sequenceOrder: 1
        }
        string nestedName;
        @Sequence {
            id: "a2",
            sequenceOrder: 2
        }
        int nestedAge;
    }[] nestedRecords;

    string taxNumber = "N/A";
};

@test:Config {groups: ["xsd", "xsd_sequence"]}
function testXMLStringSourceWithXSDSequences3() returns error? {
    string validXmlValue = 
        string `<SimpleXSDSequenceRecord><name>John</name><age>30</age><nestedRecords><nestedName>John</nestedName><nestedAge>30</nestedAge></nestedRecords><nestedRecords><nestedName>John</nestedName><nestedAge>30</nestedAge></nestedRecords></SimpleXSDSequenceRecord>`;
    SimpleXSDSequenceRecord3 validatedOutput = check parseString(validXmlValue);
    test:assertEquals(validatedOutput, {name: "John", age: 30, nestedRecords: [{nestedName: "John", nestedAge: 30}, {nestedName: "John", nestedAge: 30}], taxNumber: "N/A"});

    string invalidXmlValue = 
        string `<SimpleXSDSequenceRecord><name>John</name><age>30</age><nestedRecords><nestedName>John</nestedName><nestedAge>30</nestedAge></nestedRecords><nestedRecords><nestedAge>30</nestedAge><nestedName>John</nestedName></nestedRecords></SimpleXSDSequenceRecord>`;
    SimpleXSDSequenceRecord3|Error validatedOutput2 = parseString(invalidXmlValue);
    test:assertTrue(validatedOutput2 is error);
    test:assertEquals((<error>validatedOutput2).message(), "invalid sequence order for the element 'nestedName'");
}

@Name {
    value: "SimpleXSDSequenceRecord"
}
type SimpleXSDSequenceRecord4 record {
    @Sequence {
        id: "a1",
        sequenceOrder: 1
    }
    string name;
    @Sequence {
        id: "a1",
        sequenceOrder: 2
    }
    int age;
};

@test:Config {groups: ["xsd", "xsd_sequence"]}
function testXMLStringSourceWithXSDSequences4() returns error? {
    string invalidXmlValue2 = string `<SimpleXSDSequenceRecord><name>John</name><a>1</a><age>30</age></SimpleXSDSequenceRecord>`;
    SimpleXSDSequenceRecord4|Error validatedOutput3 = parseString(invalidXmlValue2);
    test:assertTrue(validatedOutput3 is error);
    test:assertEquals((<error>validatedOutput3).message(), "min occurrences does not reach for the element 'a1'");

    invalidXmlValue2 = string `<SimpleXSDSequenceRecord><a>1</a><name>John</name><a>1</a><age>30</age><a>1</a></SimpleXSDSequenceRecord>`;
    validatedOutput3 = parseString(invalidXmlValue2);
    test:assertTrue(validatedOutput3 is error);
    test:assertEquals((<error>validatedOutput3).message(), "min occurrences does not reach for the element 'a1'");

    invalidXmlValue2 = string `<SimpleXSDSequenceRecord><a>1</a><name>John</name><age>30</age><a>1</a></SimpleXSDSequenceRecord>`;
    validatedOutput3 = parseString(invalidXmlValue2);
    test:assertEquals(validatedOutput3, {name: "John", age: 30, a: [1, 1]});
}

@Name {
    value: "SimpleXSDSequenceRecord"
}
type SimpleXSDSequenceRecord5 record {
    @Sequence {
        id: "a1",
        sequenceOrder: 1
    }
    string[] name;
    @Sequence {
        id: "a1",
        sequenceOrder: 2
    }
    int[] age;
};

@test:Config {groups: ["xsd", "xsd_sequence"]}
function testXMLStringSourceWithXSDSequences5() returns error? {
    string invalidXmlValue2 = string `<SimpleXSDSequenceRecord><name>John</name><age>30</age><a>1</a><age>30</age></SimpleXSDSequenceRecord>`;
    SimpleXSDSequenceRecord5|Error validatedOutput3 = parseString(invalidXmlValue2);
    test:assertTrue(validatedOutput3 is error);
    test:assertEquals((<error>validatedOutput3).message(), "The XML sequence is missing required elements: 'name'");

    invalidXmlValue2 = string `<SimpleXSDSequenceRecord><name>John</name><age>30</age><a>1</a><name>John</name></SimpleXSDSequenceRecord>`;
    validatedOutput3 = parseString(invalidXmlValue2);
    test:assertTrue(validatedOutput3 is error);
    test:assertEquals((<error>validatedOutput3).message(), "The XML sequence is missing required elements: 'age'");
}

@Name {
    value: "SimpleXSDSequenceRecord"
}
type SimpleXSDSequenceRecord6 record {
    @Sequence {
        id: "a1",
        sequenceOrder: 1
    }
    string name2;
    @Sequence {
        id: "a1",
        sequenceOrder: 2
    }
    int age2;
    record { 
        @Sequence {
            id: "a2",
            sequenceOrder: 1
        }
        string name;
        @Sequence {
            id: "a2",
            sequenceOrder: 2
        }
        int age;
    } user;
};

@test:Config {groups: ["xsd", "xsd_sequence"]}
function testXMLStringSourceWithXSDSequences6() returns error? {
    string invalidXmlValue2 = string `<SimpleXSDSequenceRecord><name2>John</name2><age2>30</age2><user><name>John</name><a>1</a><age>30</age><\user></SimpleXSDSequenceRecord>`;
    SimpleXSDSequenceRecord6|Error validatedOutput3 = parseString(invalidXmlValue2);
    test:assertTrue(validatedOutput3 is error);
    test:assertEquals((<error>validatedOutput3).message(), "min occurrences does not reach for the element 'a2'");

    invalidXmlValue2 = string `<SimpleXSDSequenceRecord><a>1</a><name2>John</name2><age2>30</age2><user><a>1</a><name>John</name><a>1</a><age>30</age><a>1</a><\user></SimpleXSDSequenceRecord>`;
    validatedOutput3 = parseString(invalidXmlValue2);
    test:assertTrue(validatedOutput3 is error);
    test:assertEquals((<error>validatedOutput3).message(), "min occurrences does not reach for the element 'a2'");

    invalidXmlValue2 = string `<SimpleXSDSequenceRecord><a>1</a><name2>John</name2><age2>30</age2><a>1</a><user><a>1</a><name>John</name><age>30</age><a>1</a></user></SimpleXSDSequenceRecord>`;
    validatedOutput3 = parseString(invalidXmlValue2);
    test:assertEquals(validatedOutput3, {name2: "John", age2: 30, a: [1, 1], user: {name: "John", age: 30, a: [1, 1]}});
}

@Name {
    value: "SimpleXSDSequenceRecord"
}
type SimpleXSDSequenceRecord7 record {
    @Sequence {
        id: "a1",
        sequenceOrder: 1
    }
    string[] name;
    @Sequence {
        id: "a1",
        sequenceOrder: 2
    }
    int[] age;

    record {
        @Sequence {
            id: "a1",
            sequenceOrder: 1
        }
        string[] name;
        @Sequence {
            id: "a1",
            sequenceOrder: 2
        }
        int[] age;
    } user;
};

@test:Config {groups: ["xsd", "xsd_sequence"]}
function testXMLStringSourceWithXSDSequences7() returns error? {
    string invalidXmlValue2 = string `<SimpleXSDSequenceRecord><name2>John</name2><age2>30</age2><user><name>John</name><age>30</age><a>1</a><age>30</age></user></SimpleXSDSequenceRecord>`;
    SimpleXSDSequenceRecord7|Error validatedOutput3 = parseString(invalidXmlValue2);
    test:assertTrue(validatedOutput3 is error);
    test:assertEquals((<error>validatedOutput3).message(), "The XML sequence is missing required elements: 'name'");

    invalidXmlValue2 = string `<SimpleXSDSequenceRecord><name2>John</name2><age2>30</age2><user><name>John</name><age>30</age><a>1</a><name>John</name></user></SimpleXSDSequenceRecord>`;
    validatedOutput3 = parseString(invalidXmlValue2);
    test:assertTrue(validatedOutput3 is error);
    test:assertEquals((<error>validatedOutput3).message(), "The XML sequence is missing required elements: 'age'");
}

@Name {
    value: "SimpleXSDSequenceRecord"
}
type SimpleXSDSequenceRecord8 record {
    @Sequence {
        id: "a1",
        sequenceOrder: 1,
        maxOccurs: 3
    }
    string[] name;
    @Sequence {
        id: "a1",
        sequenceOrder: 2,
        maxOccurs: 3
    }
    int[] age;

    @Sequence {
        id: "a2",
        sequenceOrder: 1,
        maxOccurs: 3
    }
    string[] name2;
    @Sequence {
        id: "a2",
        sequenceOrder: 2,
        maxOccurs: 3
    }
    int[] age2;
};

@test:Config {groups: ["xsd", "xsd_sequence"]}
function testXMLStringSourceWithXSDSequences8() returns error? {
    string invalidXmlValue2 = string `<SimpleXSDSequenceRecord><name>John</name><age>30</age><name>John</name><age>30</age><name2>John</name2><age2>30</age2><name2>John</name2><age2>30</age2></SimpleXSDSequenceRecord>`;
    SimpleXSDSequenceRecord8|Error validatedOutput3 = parseString(invalidXmlValue2);
    test:assertEquals(validatedOutput3, {name: ["John", "John"], age: [30, 30], name2: ["John", "John"], age2: [30, 30]});

    string invalidXmlValue3 = string `<SimpleXSDSequenceRecord><name>John</name><age>30</age><name>John</name><name2>John</name2><age2>30</age2><name2>John</name2><age2>30</age2><age>30</age></SimpleXSDSequenceRecord>`;
    SimpleXSDSequenceRecord8|Error validatedOutput4 = parseString(invalidXmlValue3);
    test:assertTrue(validatedOutput4 is error);
    test:assertEquals((<error>validatedOutput4).message(), "The XML sequence is missing required elements: 'age'");
}

@Name {
    value: "A"
}
type SimpleXSDSequenceRecordWithMaxOccursTest record {
    @Sequence {
        id: "a2",
        sequenceOrder: 2,
        maxOccurs: 2
    }
    string[] name;

    @Sequence {
        id: "a2",
        sequenceOrder: 1,
        maxOccurs: 2
    }
    int[] id;
};

@test:Config {groups: ["xsd", "xsd_sequence"]}
function testXMLStringSourceWithXSDSequencesWithMaxOccures() returns error? {
    string validXmlValue = string `<A><id>1</id><name>John</name><id>1</id><name>John</name></A>`;
    SimpleXSDSequenceRecordWithMaxOccursTest validatedOutput = check parseString(validXmlValue);
    test:assertEquals(validatedOutput, {"name":["John","John"],"id":[1,1]});

    string invalidXmlValue = string `<A><id>1</id><name>John</name><id>1</id><name>John</name><id>1</id><name>John</name></A>`;
    SimpleXSDSequenceRecordWithMaxOccursTest|Error validatedOutput2 = parseString(invalidXmlValue);
    test:assertTrue(validatedOutput2 is error);
    test:assertEquals((<error>validatedOutput2).message(), "max occurrences exceeded for the element 'name'");

    string invalidXmlValue2 = string `<A><id>1</id><name>John</name><name>John</name><id>1</id></A>`;
    SimpleXSDSequenceRecordWithMaxOccursTest|Error validatedOutput3 = parseString(invalidXmlValue2);
    test:assertTrue(validatedOutput3 is error);
    test:assertEquals((<error>validatedOutput3).message(), "invalid sequence order for the element 'id'");

    string invalidXmlValue3 = string `<A><id>1</id><id>1</id><name>John</name><name>John</name></A>`;
    SimpleXSDSequenceRecordWithMaxOccursTest|Error validatedOutput4 = parseString(invalidXmlValue3);
    test:assertTrue(validatedOutput4 is error);
    test:assertEquals((<error>validatedOutput4).message(), "invalid sequence order for the element 'id'");
}

// Commented Due to https://github.com/ballerina-platform/ballerina-library/issues/7303

// @Name {
//     value: "A"
// }
// type SimpleXSDSequenceRecordWithMaxOccursTes2 record {
//     @Sequence {
//         id: "a1",
//         sequenceOrder: 1
//     }
//     string name;
//     @Sequence {
//         id: "a1",
//         sequenceOrder: 2
//     }
//     int age;
//     record {
//         @Sequence {
//             id: "a2",
//             sequenceOrder: 2,
//             maxOccurs: 2
//         }
//         string[] name;

//         @Sequence {
//             id: "a2",
//             sequenceOrder: 1,
//             maxOccurs: 2
//         }
//         int[] id;
//     } user;
// };

// @test:Config {groups: ["xsd", "xsd_sequence"]}
// function testXMLStringSourceWithXSDSequencesWithMaxOccures2() returns error? {

//     // string validXmlValue = string `<A><name>John</name><age>23</age><user><id>1</id><name>John</name><id>1</id><name>John</name></user></A>`;
//     // SimpleXSDSequenceRecordWithMaxOccursTest2 validatedOutput = check parseString(validXmlValue);
//     // test:assertEquals(validatedOutput, {name: "John", age: 23, user: {"name":["John","John"],"id":[1,1]}});

//     // string invalidXmlValue = string `<A><name>John</name><age>23</age><user><id>1</id><name>John</name><id>1</id><name>John</name><id>1</id><name>John</name><id>1</id><name>John</name></user></A>`;
//     // SimpleXSDSequenceRecordWithMaxOccursTest2|Error validatedOutput2 = parseString(invalidXmlValue);
//     // test:assertTrue(validatedOutput2 is error);
//     // test:assertEquals((<error>validatedOutput2).message(), "max occurrences exceeded for the element 'name'");

//     // string invalidXmlValue2 = string `<A><name>John</name><age>23</age><user><id>1</id><name>John</name><name>John</name><id>1</id></user></A>`;
//     // SimpleXSDSequenceRecordWithMaxOccursTest2|Error validatedOutput3 = parseString(invalidXmlValue2);
//     // test:assertTrue(validatedOutput3 is error);
//     // test:assertEquals((<error>validatedOutput3).message(), "invalid sequence order for the element 'id'");
// }

@Name {
    value: "A"
}
type SimpleXSDSequenceRecordWithMaxOccursTes3 record {
    @Sequence {
        id: "a1",
        sequenceOrder: 1
    }
    string name;
    @Sequence {
        id: "a1",
        sequenceOrder: 2
    }
    int age;
    record {
        @Sequence {
            id: "a2",
            sequenceOrder: 2,
            maxOccurs: 2
        }
        string[] name2;

        @Sequence {
            id: "a2",
            sequenceOrder: 1,
            maxOccurs: 2
        }
        int[] id;
    } user;
};

@test:Config {groups: ["xsd", "xsd_sequence"]}
function testXMLStringSourceWithXSDSequencesWithMaxOccures3() returns error? {
    string validXmlValue = string `<A><name>John</name><age>23</age><user><id>1</id><name2>John</name2><id>1</id><name2>John</name2></user></A>`;
    SimpleXSDSequenceRecordWithMaxOccursTes3 validatedOutput = check parseString(validXmlValue);
    test:assertEquals(validatedOutput, {name: "John", age: 23, user: {"name2":["John","John"],"id":[1,1]}});

    string invalidXmlValue = string `<A><name>John</name><age>23</age><user><id>1</id><name2>John</name2><id>1</id><name2>John</name2><id>1</id><name2>John</name2><id>1</id><name2>John</name2></user></A>`;
    SimpleXSDSequenceRecordWithMaxOccursTes3|Error validatedOutput2 = parseString(invalidXmlValue);
    test:assertTrue(validatedOutput2 is error);
    test:assertEquals((<error>validatedOutput2).message(), "max occurrences exceeded for the element 'name2'");

    string invalidXmlValue2 = string `<A><name>John</name><age>23</age><user><id>1</id><name2>John</name2><name2>John</name2><id>1</id></user></A>`;
    SimpleXSDSequenceRecordWithMaxOccursTes3|Error validatedOutput3 = parseString(invalidXmlValue2);
    test:assertTrue(validatedOutput3 is error);
    test:assertEquals((<error>validatedOutput3).message(), "invalid sequence order for the element 'id'");
}

@Name {
    value: "A"
}
type SimpleXSDSequenceRecordWithMinOccursTest record {
    @Sequence {
        id: "a2",
        sequenceOrder: 2,
        minOccurs: 2
    }
    string[] name;

    @Sequence {
        id: "a2",
        sequenceOrder: 1,
        minOccurs: 2
    }
    int[] id;
};

@test:Config {groups: ["xsd", "xsd_sequence"]}
function testXMLStringSourceWithXSDSequencesWithMinOccures() returns error? {
    string validXmlValue = string `<A><id>1</id><name>John</name><id>1</id><name>John</name></A>`;
    SimpleXSDSequenceRecordWithMinOccursTest validatedOutput = check parseString(validXmlValue);
    test:assertEquals(validatedOutput, {"name":["John","John"],"id":[1,1]});

    string invalidXmlValue = string `<A><id>1</id><name>John</name></A>`;
    SimpleXSDSequenceRecordWithMinOccursTest|Error validatedOutput2 = parseString(invalidXmlValue);
    test:assertTrue(validatedOutput2 is error);
    test:assertEquals((<error>validatedOutput2).message(), "min occurrences does not reach for the element 'a2'");

    string invalidXmlValue2 = string `<A><id>1</id><name>John</name><name>John</name><id>1</id></A>`;
    SimpleXSDSequenceRecordWithMinOccursTest|Error validatedOutput3 = parseString(invalidXmlValue2);
    test:assertTrue(validatedOutput3 is error);
    test:assertEquals((<error>validatedOutput3).message(), "invalid sequence order for the element 'id'");

    string invalidXmlValue3 = string `<A><id>1</id><name>John</name><id>1</id></A>`;
    SimpleXSDSequenceRecordWithMinOccursTest|Error validatedOutput4 = parseString(invalidXmlValue3);
    test:assertTrue(validatedOutput4 is error);
    test:assertEquals((<error>validatedOutput4).message(), "min occurrences does not reach for the element 'a2'");

    string invalidXmlValue4 = string `<A><id>1</id><name>John</name><id>1</id><name>John</name><name>John2</name></A>`;
    SimpleXSDSequenceRecordWithMinOccursTest|Error validatedOutput5 = parseString(invalidXmlValue4);
    test:assertTrue(validatedOutput5 is error);
    test:assertEquals((<error>validatedOutput5).message(), "The XML sequence is missing required elements: 'id'");

    string invalidXmlValue5 = string `<A><id>1</id><name>John</name><id>1</id><name>John</name><id>1</id></A>`;
    SimpleXSDSequenceRecordWithMinOccursTest|Error validatedOutput6 = parseString(invalidXmlValue5);
    test:assertTrue(validatedOutput6 is error);
    test:assertEquals((<error>validatedOutput6).message(), "The XML sequence is missing required elements: 'name'");
}

@Name {
    value: "A"
}
type SimpleXSDSequenceRecordWithMinOccursTest2 record {
    @Sequence {
        id: "a2",
        sequenceOrder: 2,
        minOccurs: 2
    }
    string[] name;

    @Sequence {
        id: "a2",
        sequenceOrder: 1,
        minOccurs: 2
    }
    int[] id;

    record {
        @Sequence {
            id: "a2",
            sequenceOrder: 2,
            minOccurs: 2
        }
        string[] name2;

        @Sequence {
            id: "a2",
            sequenceOrder: 1,
            minOccurs: 2
        }
        int[] id2;
    } user;
};

@test:Config {groups: ["xsd", "xsd_sequence"]}
function testXMLStringSourceWithXSDSequencesWithMinOccures2() returns error? {
    string validXmlValue = string `<A><id>1</id><name>John</name><id>1</id><name>John</name><user><id2>1</id2><name2>John</name2><id2>1</id2><name2>John</name2></user></A>`;
    SimpleXSDSequenceRecordWithMinOccursTest2 validatedOutput = check parseString(validXmlValue);
    test:assertEquals(validatedOutput, {"name":["John","John"],"id":[1,1], user: {name2: ["John","John"], id2: [1,1]}});

    string invalidXmlValue = string `<A><id>1</id><name>John</name><id>1</id><name>John</name><user><id2>1</id2><name2>John</name2></user></A>`;
    SimpleXSDSequenceRecordWithMinOccursTest2|Error validatedOutput2 = parseString(invalidXmlValue);
    test:assertTrue(validatedOutput2 is error);
    test:assertEquals((<error>validatedOutput2).message(), "min occurrences does not reach for the element 'a2'");

    string invalidXmlValue2 = string `<A><id>1</id><name>John</name><id>1</id><name>John</name><user><id2>1</id2><name2>John</name2><name2>John</name2><id2>1</id2></user></A>`;
    SimpleXSDSequenceRecordWithMinOccursTest2|Error validatedOutput3 = parseString(invalidXmlValue2);
    test:assertTrue(validatedOutput3 is error);
    test:assertEquals((<error>validatedOutput3).message(), "invalid sequence order for the element 'id2'");

    string invalidXmlValue3 = string `<A><id>1</id><name>John</name><id>1</id><name>John</name><user><id2>1</id2><name2>John</name2><id2>1</id2></user></A>`;
    SimpleXSDSequenceRecordWithMinOccursTest2|Error validatedOutput4 = parseString(invalidXmlValue3);
    test:assertTrue(validatedOutput4 is error);
    test:assertEquals((<error>validatedOutput4).message(), "min occurrences does not reach for the element 'a2'");

    string invalidXmlValue4 = string `<A><id>1</id><name>John</name><id>1</id><name>John</name><user><id2>1</id2><name2>John</name2><id2>1</id2><name2>John</name2><name2>John2</name2></user></A>`;
    SimpleXSDSequenceRecordWithMinOccursTest2|Error validatedOutput5 = parseString(invalidXmlValue4);
    test:assertTrue(validatedOutput5 is error);
    test:assertEquals((<error>validatedOutput5).message(), "The XML sequence is missing required elements: 'id2'");

    string invalidXmlValue5 = string `<A><id>1</id><name>John</name><id>1</id><name>John</name><user><id2>1</id2><name2>John</name2><id2>1</id2><name2>John</name2><id2>1</id2></user></A>`;
    SimpleXSDSequenceRecordWithMinOccursTest2|Error validatedOutput6 = parseString(invalidXmlValue5);
    test:assertTrue(validatedOutput6 is error);
    test:assertEquals((<error>validatedOutput6).message(), "The XML sequence is missing required elements: 'name2'");
}
