// Copyright (c) 2023, WSO2 LLC. (https://www.wso2.com).
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

type XsdSequenceWithNameAnnotationWithXmlValue record {
    @Sequence {
        minOccurs: 0,
        maxOccurs: 1
    }
    Seq_EA1_NameAnnotationWithXmlValue seq_EA1_NameAnnotationWithXmlValue;
};

type Seq_EA1_NameAnnotationWithXmlValue record {

    @Name {value: "A1"}
    @Element {
        maxOccurs: 1,
        minOccurs: 0
    }
    @SequenceOrder {
        value: 1
    }
    string EA1?;

    @Name {value: "A2"}
    @Element {
        maxOccurs: 1,
        minOccurs: 0
    }
    @SequenceOrder {
        value: 2
    }
    string EA2?;

    @Name {value: "A3"}
    @Element {
        maxOccurs: 4,
        minOccurs: 2
    }
    @SequenceOrder {
        value: 3
    }
    string[] EA3?;
};

@test:Config {groups: ["xsd", "xsd_sequence", "xsd_element", "xsd_element_and_sequence"]}
function testXsdSequenceWithNameAnnotationWithXmlValue() returns error? {
    xml xmlValue;
    XsdSequenceWithNameAnnotationWithXmlValue|Error v;

    xmlValue = xml `<Root><A1>ABC</A1><A2>ABC</A2></Root>`;
    v = parseAsType(xmlValue);
    test:assertTrue(v is Error);
    test:assertEquals((<Error>v).message(), "Element(s) 'EA3' is not found in 'seq_EA1_NameAnnotationWithXmlValue'");
    
    xmlValue = xml `<Root><A1>ABC</A1><A2>ABC</A2><A3>AB</A3><A3>AB</A3><A3>AB</A3></Root>`;
    v = parseAsType(xmlValue);
    test:assertEquals(v, {seq_EA1_NameAnnotationWithXmlValue: {EA1: "ABC", EA2: "ABC", EA3: ["AB", "AB", "AB"]}});

    xmlValue = xml `<Root><A2>ABC</A2><A3>AB</A3><A3>AB</A3></Root>`;
    v = parseAsType(xmlValue);
    test:assertEquals(v, {"seq_EA1_NameAnnotationWithXmlValue":{"EA2": "ABC", EA3: ["AB", "AB"]}});

    xmlValue = xml `<Root><A2>ABC</A2><A3>AB</A3><A3>AB</A3><A3>AB</A3></Root>`;
    v = parseAsType(xmlValue);
    test:assertEquals(v, {"seq_EA1_NameAnnotationWithXmlValue":{"EA2": "ABC", EA3: ["AB", "AB", "AB"]}});

    xmlValue = xml `<Root><A3>AB</A3><A3>AB</A3></Root>`;
    v = parseAsType(xmlValue);
    test:assertEquals(v, {"seq_EA1_NameAnnotationWithXmlValue":{EA3: ["AB", "AB"]}});

    xmlValue = xml `<Root><A3>AB</A3><A3>AB</A3><A3>AB</A3><A3>AB</A3><A3>AB</A3><A3>AB</A3></Root>`;
    v = parseAsType(xmlValue);
    test:assertTrue(v is Error);
    test:assertEquals((<Error>v).message(), "'A3' occurs more than the max allowed times");

    xmlValue = xml `<Root><A1>ABC</A1><A3>AB</A3><A3>AB</A3></Root>`;
    v = parseAsType(xmlValue);
    test:assertEquals(v, {"seq_EA1_NameAnnotationWithXmlValue":{"EA1": "ABC", EA3: ["AB", "AB"]}});

    xmlValue = xml `<Root><A1>ABC</A1><A2>ABC</A2><A3>AB</A3></Root>`;
    v = parseAsType(xmlValue);
    test:assertTrue(v is Error);
    test:assertEquals((<Error>v).message(), "'A3' occurs less than the min required times");

    xmlValue = xml `<Root><A2>ABC</A2><A3>AB</A3></Root>`;
    v = parseAsType(xmlValue);
    test:assertTrue(v is Error);
    test:assertEquals((<Error>v).message(), "'A3' occurs less than the min required times");

    xmlValue = xml `<Root><A2>ABC</A2><A3>AB</A3></Root>`;
    v = parseAsType(xmlValue);
    test:assertTrue(v is Error);
    test:assertEquals((<Error>v).message(), "'A3' occurs less than the min required times");

    xmlValue = xml `<Root><A3>AB</A3></Root>`;
    v = parseAsType(xmlValue);
    test:assertTrue(v is Error);
    test:assertEquals((<Error>v).message(), "'A3' occurs less than the min required times");

    xmlValue = xml `<Root><A1>ABC</A1><A3>AB</A3></Root>`;
    v = parseAsType(xmlValue);
    test:assertTrue(v is Error);
    test:assertEquals((<Error>v).message(), "'A3' occurs less than the min required times");
}

type XsdSequenceWithNameAnnotationWithXmlValue2 record {
    @Sequence {
        minOccurs: 0,
        maxOccurs: 1
    }
    Seq_EA2_NameAnnotationWithXmlValue seq_EA2_NameAnnotationWithXmlValue;
};

type Seq_EA2_NameAnnotationWithXmlValue record {
    @SequenceOrder {
        value: 1
    }
    record {
        @Element {
            maxOccurs: 1,
            minOccurs: 0
        }
        @SequenceOrder {
            value: 1
        }
        @Name {value: "A1"}
        string EA1?;

        @Element {
            maxOccurs: 1,
            minOccurs: 0
        }
        @SequenceOrder {
            value: 2
        }
        @Name {value: "A2"}
        string EA2?;

        @Element {
            maxOccurs: 4,
            minOccurs: 2
        }

        @Name {value: "A3"}
        @SequenceOrder {
            value: 3
        }
        string[] EA3?;
    } EA;
};

@test:Config {groups: ["xsd", "xsd_sequence", "xsd_element", "xsd_element_and_sequence"]}
function testXsdSequenceWithNameAnnotationWithXmlValue2() returns error? {
    xml xmlValue;
    XsdSequenceWithNameAnnotationWithXmlValue2|Error v;

    xmlValue = xml `<Root><EA><A1>ABC</A1><A2>ABC</A2></EA></Root>`;
    v = parseAsType(xmlValue);
    test:assertTrue(v is Error);
    test:assertEquals((<Error>v).message(), "'A3' occurs less than the min required times");
    
    xmlValue = xml `<Root><EA><A1>ABC</A1><A2>ABC</A2><A3>AB</A3></EA></Root>`;
    v = parseAsType(xmlValue);
    test:assertTrue(v is Error);
    test:assertEquals((<Error>v).message(), "'A3' occurs less than the min required times");

    xmlValue = xml `<Root><EA><A1>ABC</A1><A2>ABC</A2><A3>AB</A3><A3>CD</A3></EA></Root>`;
    v = parseAsType(xmlValue);    
    test:assertEquals(v, {seq_EA2_NameAnnotationWithXmlValue:  {EA: {EA1: "ABC", EA2: "ABC", EA3: ["AB", "CD"]}}});

    xmlValue = xml `<Root><EA><A2>ABC</A2><A3>AB</A3><A3>AB</A3></EA></Root>`;
    v = parseAsType(xmlValue);
    test:assertEquals(v, {"seq_EA2_NameAnnotationWithXmlValue": {EA: {"EA2": "ABC", EA3: ["AB", "AB"]}}});

    xmlValue = xml `<Root><EA><A2>ABC</A2><A3>AB</A3><A3>AB</A3></EA></Root>`;
    v = parseAsType(xmlValue);
    test:assertEquals(v, {"seq_EA2_NameAnnotationWithXmlValue": {EA: {"EA2": "ABC", EA3: ["AB", "AB"]}}});

    xmlValue = xml `<Root><EA><A3>AB</A3><A3>AB</A3></EA></Root>`;
    v = parseAsType(xmlValue);
    test:assertEquals(v, {"seq_EA2_NameAnnotationWithXmlValue": {EA: {EA3: ["AB", "AB"]}}});

    xmlValue = xml `<Root><EA><A3>AB</A3><A3>AB</A3><A3>AB</A3><A3>AB</A3><A3>AB</A3><A3>AB</A3></EA></Root>`;
    v = parseAsType(xmlValue);
    test:assertTrue(v is Error);
    test:assertEquals((<Error>v).message(), "'A3' occurs more than the max allowed times");

    xmlValue = xml `<Root><EA><A1>ABC</A1><A3>AB</A3><A3>AB</A3></EA></Root>`;
    v = parseAsType(xmlValue);
    test:assertEquals(v, {"seq_EA2_NameAnnotationWithXmlValue": {EA: {"EA1": "ABC", EA3: ["AB", "AB"]}}});

    xmlValue = xml `<Root><EA><A1>ABC</A1><A2>ABC</A2><A3>CD</A3></EA></Root>`;
    v = parseAsType(xmlValue);    
    test:assertTrue(v is Error);
    test:assertEquals((<Error>v).message(), "'A3' occurs less than the min required times");

    xmlValue = xml `<Root><EA><A2>ABC</A2><A3>AB</A3></EA></Root>`;
    v = parseAsType(xmlValue);
    test:assertTrue(v is Error);
    test:assertEquals((<Error>v).message(), "'A3' occurs less than the min required times");

    xmlValue = xml `<Root><EA><A2>ABC</A2><A3>AB</A3></EA></Root>`;
    v = parseAsType(xmlValue);
    test:assertTrue(v is Error);
    test:assertEquals((<Error>v).message(), "'A3' occurs less than the min required times");

    xmlValue = xml `<Root><EA><A3>AB</A3></EA></Root>`;
    v = parseAsType(xmlValue);
    test:assertTrue(v is Error);
    test:assertEquals((<Error>v).message(), "'A3' occurs less than the min required times");

    xmlValue = xml `<Root><EA><A1>ABC</A1><A3>AB</A3></EA></Root>`;
    v = parseAsType(xmlValue);
    test:assertTrue(v is Error);
    test:assertEquals((<Error>v).message(), "'A3' occurs less than the min required times");
}
