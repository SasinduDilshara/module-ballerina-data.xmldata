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

@Name {
    value: "A"
}
type SimpleXSDSequenceRecordWithMaxOccursTes2 record {
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
        string[] name;

        @Sequence {
            id: "a2",
            sequenceOrder: 1,
            maxOccurs: 2
        }
        int[] id;
    } user;
};

// Commented Due to https://github.com/ballerina-platform/ballerina-library/issues/7303

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
    test:assertEquals((<error>validatedOutput2).message(), "min occurrences does not reach for the element 'name'");

    string invalidXmlValue2 = string `<A><id>1</id><name>John</name><name>John</name><id>1</id></A>`;
    SimpleXSDSequenceRecordWithMinOccursTest|Error validatedOutput3 = parseString(invalidXmlValue2);
    test:assertTrue(validatedOutput3 is error);
    test:assertEquals((<error>validatedOutput3).message(), "invalid sequence order for the element 'id'");

    string invalidXmlValue3 = string `<A><id>1</id><name>John</name><id>1</id></A>`;
    SimpleXSDSequenceRecordWithMinOccursTest|Error validatedOutput4 = parseString(invalidXmlValue3);
    test:assertTrue(validatedOutput4 is error);
    test:assertEquals((<error>validatedOutput4).message(), "min occurrences does not reach for the element 'name'");

    string invalidXmlValue4 = string `<A><id>1</id><name>John</name><id>1</id><name>John</name><name>John2</name></A>`;
    SimpleXSDSequenceRecordWithMinOccursTest|Error validatedOutput5 = parseString(invalidXmlValue4);
    test:assertTrue(validatedOutput5 is error);
    test:assertEquals((<error>validatedOutput5).message(), "The XML sequence is missing required elements: 'id'");

    string invalidXmlValue5 = string `<A><id>1</id><name>John</name><id>1</id><name>John</name><id>1</id></A>`;
    SimpleXSDSequenceRecordWithMinOccursTest|Error validatedOutput6 = parseString(invalidXmlValue5);
    test:assertTrue(validatedOutput6 is error);
    test:assertEquals((<error>validatedOutput6).message(), "The XML sequence is missing required elements: 'name'");
}
