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

@Name {
    value: "Root"
}
type XsdChoiceArrayWithXmlValue record {|
    @Choice {
        minOccurs: 1,
        maxOccurs: 2
    }
    Choice_XsdChoiceArrayWithXmlValue choice_XsdChoiceArrayWithXmlValue;
|};

type Choice_XsdChoiceArrayWithXmlValue record {|
    int[] age?;
    float[] salary?;
|};

@test:Config {groups: ["xsd", "xsd_choice"]}
function testXsdChoiceArrayWithXmlValue() returns error? {
    xml xmlValue;
    XsdChoiceArrayWithXmlValue|Error v;

    xmlValue = xml `<Root><age>13</age><salary>11.1</salary></Root>`;
    v = parseAsType(xmlValue);
    test:assertEquals(v, {choice_XsdChoiceArrayWithXmlValue: {age: [13], salary: [11.1]}});
    test:assertEquals(toXml(check v), xmlValue);

    xmlValue = xml `<Root><age>13</age><age>12</age></Root>`;
    v = parseAsType(xmlValue);
    test:assertEquals(v, {choice_XsdChoiceArrayWithXmlValue: {age: [13, 12]}});
    test:assertEquals(toXml(check v), xmlValue);

    xmlValue = xml `<Root><salary>11.1</salary><salary>12.1</salary></Root>`;
    v = parseAsType(xmlValue);
    test:assertEquals(v, {choice_XsdChoiceArrayWithXmlValue: {salary: [11.1, 12.1]}});
    test:assertEquals(toXml(check v), xmlValue);

    xmlValue = xml `<Root><age>13</age><salary>11.1</salary><age>14</age><salary>14.1</salary><age>15</age><salary>15.1</salary></Root>`;
    v = parseAsType(xmlValue);
    test:assertTrue(v is error);
    test:assertEquals((<Error>v).message(), "'choice_XsdChoiceArrayWithXmlValue' occurs more than the max allowed times");
    xml|Error toXmlResult = toXml(<XsdChoiceArrayWithXmlValue>{choice_XsdChoiceArrayWithXmlValue: {age: [13, 14, 15], salary: [11.1, 14.1, 15.1]}});
    test:assertTrue(toXmlResult is error);
    test:assertEquals((<Error>toXmlResult).message(), "'choice_XsdChoiceArrayWithXmlValue' occurs more than the max allowed times");
}

@Name {
    value: "Root"
}
type XsdChoiceArrayWithXmlValue2 record {|
    @Choice {
        minOccurs: 1,
        maxOccurs: 2
    }
    Choice_XsdChoiceArrayWithXmlValue2 choice_XsdChoiceArrayWithXmlValue2;

    @Choice {
        minOccurs: 0,
        maxOccurs: 2
    }
    Choice_XsdChoiceArrayWithXmlValue2_2 choice_XsdChoiceArrayWithXmlValue2_2?;
|};

type Choice_XsdChoiceArrayWithXmlValue2 record {|
    int[] age?;
    float[] salary?;
|};

type Choice_XsdChoiceArrayWithXmlValue2_2 record {|
    int[] age2?;
    float[] salary2?;
|};

@test:Config {groups: ["xsd", "xsd_choice"]}
function testXsdChoiceArrayWithXmlValue2() returns error? {
    xml xmlValue;
    XsdChoiceArrayWithXmlValue2|Error v;

    xmlValue = xml `<Root><age>13</age><salary>11.1</salary><age2>13</age2><salary2>11.1</salary2></Root>`;
    v = parseAsType(xmlValue);
    test:assertEquals(v, {choice_XsdChoiceArrayWithXmlValue2: {age: [13], salary: [11.1]}, choice_XsdChoiceArrayWithXmlValue2_2: {age2: [13], salary2: [11.1]}});
    test:assertEquals(toXml(check v), xmlValue);

    xmlValue = xml `<Root><age>13</age><age>13</age><age2>13</age2><age2>13</age2></Root>`;
    v = parseAsType(xmlValue);
    test:assertEquals(v, {choice_XsdChoiceArrayWithXmlValue2: {age: [13, 13]}, choice_XsdChoiceArrayWithXmlValue2_2: {age2: [13, 13]}});
    test:assertEquals(toXml(check v), xmlValue);

    xmlValue = xml `<Root><age>13</age><age>13</age><age2>13</age2><salary2>11.1</salary2></Root>`;
    v = parseAsType(xmlValue);
    test:assertEquals(v, {choice_XsdChoiceArrayWithXmlValue2: {age: [13, 13]}, choice_XsdChoiceArrayWithXmlValue2_2: {age2: [13], salary2: [11.1]}});
    test:assertEquals(toXml(check v), xmlValue);

    xmlValue = xml `<Root><age>13</age><age>13</age><age2>13</age2><salary2>11.1</salary2><age2>14</age2><age2>15</age2></Root>`;
    v = parseAsType(xmlValue);
    test:assertTrue(v is error);
    test:assertEquals((<Error>v).message(), "'choice_XsdChoiceArrayWithXmlValue2_2' occurs more than the max allowed times");
    xml|Error toXmlResult = toXml(<XsdChoiceArrayWithXmlValue2>{choice_XsdChoiceArrayWithXmlValue2: {age: [13], salary: []}, choice_XsdChoiceArrayWithXmlValue2_2: {age2: [13, 14, 15], salary2: [11.1]}});
    test:assertTrue(toXmlResult is error);
    test:assertEquals((<Error>toXmlResult).message(), "'choice_XsdChoiceArrayWithXmlValue2_2' occurs more than the max allowed times");

    xmlValue = xml `<Root><age>13</age><age>13</age><age>13</age><age2>13</age2></Root>`;
    v = parseAsType(xmlValue);
    test:assertTrue(v is error);
    test:assertEquals((<Error>v).message(), "'choice_XsdChoiceArrayWithXmlValue2' occurs more than the max allowed times");
    toXmlResult = toXml(<XsdChoiceArrayWithXmlValue2>{choice_XsdChoiceArrayWithXmlValue2: {age: [13, 14, 15], salary: [11.1, 14.1, 15.1]}});
    test:assertTrue(toXmlResult is error);
    test:assertEquals((<Error>toXmlResult).message(), "'choice_XsdChoiceArrayWithXmlValue2' occurs more than the max allowed times");

    xmlValue = xml `<Root><age>13</age><age>13</age></Root>`;
    v = parseAsType(xmlValue);
    test:assertEquals(v, {choice_XsdChoiceArrayWithXmlValue2: {age: [13, 13]}});

    xmlValue = xml `<Root><age2>13</age2><age2>13</age2></Root>`;
    v = parseAsType(xmlValue);
    test:assertTrue(v is error);
    test:assertEquals((<Error>v).message(), "required field 'choice_XsdChoiceArrayWithXmlValue2' not present in XML");
}

@Name {
    value: "Root"
}
type XSDChoiceArrayWithXmlValueXsdChoiceArrayWithXmlValueRecord13 record {
    @Choice {
        minOccurs: 1,
        maxOccurs: 3
    }
    Choice_XSDChoiceArrayWithXmlValueXsdChoiceArrayWithXmlValueRecord13_1 choice_XSDChoiceArrayWithXmlValueXsdChoiceArrayWithXmlValueRecord13_1;

    @Choice {
        minOccurs: 2,
        maxOccurs: 3
    }
    Choice_XSDChoiceArrayWithXmlValueXsdChoiceArrayWithXmlValueRecord13_2 choice_XSDChoiceArrayWithXmlValueXsdChoiceArrayWithXmlValueRecord13_2;
};

type Choice_XSDChoiceArrayWithXmlValueXsdChoiceArrayWithXmlValueRecord13_1 record {
    Choice_Array_A_3[] field1?;
    Choice_Array_B_3[] field2?;
    Choice_Array_C_3[] field3?;
};

type Choice_XSDChoiceArrayWithXmlValueXsdChoiceArrayWithXmlValueRecord13_2 record {
    Choice_Array_D_3[] field4?;
    Choice_Array_E_3[] field5?;
    Choice__Array_F_3[] field6?;
};

@test:Config {groups: ["xsd", "xsd_choice"]}
function testXSDChoiceArrayWithXmlValueXsdChoiceArrayWithXmlValueRecord4() returns error? {
    xml xmlValue = xml `<Root><field1><a>1</a><b>2</b><c>3</c></field1><field2><d>1</d><e>2</e><f>3</f></field2><field3><g>1</g><h>2</h><i>3</i></field3><field4><a>1</a><b>2</b><c>3</c></field4><field5><d>1</d><e>2</e><f>3</f></field5><field6><g>1</g><h>2</h><i>3</i></field6></Root>`;
    XSDChoiceArrayWithXmlValueXsdChoiceArrayWithXmlValueRecord13|Error v2 = parseAsType(xmlValue);
    test:assertEquals(v2, {choice_XSDChoiceArrayWithXmlValueXsdChoiceArrayWithXmlValueRecord13_1: {field1: [{value1: {a: ["1"], b:["2"], c: ["3"]}}],field2: [{value2: {d: ["1"], e: ["2"], f: ["3"]}}], field3: [{value3: {g: ["1"], h: ["2"], i: ["3"]}}]}, choice_XSDChoiceArrayWithXmlValueXsdChoiceArrayWithXmlValueRecord13_2: {field4: [{value1: {a: ["1"], b: ["2"], c: ["3"]}}], field5: [{value2: {d: ["1"], e: ["2"], f:["3"]}}], field6: [{value3: {g: ["1"], h: ["2"], i: ["3"]}}]}});
    test:assertEquals(toXml(check v2), xmlValue);

    xmlValue = xml `<Root><field1><b>2</b><b>2</b></field1><field1><a>1</a><b>2</b><c>3</c></field1><field3><h>2</h><i>3</i><i>3</i></field3><field5><d>1</d><e>2</e><f>3</f></field5><field5><d>1</d><e>2</e><f>3</f></field5><field6><g>1</g><h>2</h><i>3</i></field6></Root>`;
    v2 = parseAsType(xmlValue);
    test:assertEquals(v2, {choice_XSDChoiceArrayWithXmlValueXsdChoiceArrayWithXmlValueRecord13_1: {field1: [{value1: {b:["2", "2"]}}, {value1: {a: ["1"], b:["2"], c: ["3"]}}], field3: [{value3: {h: ["2"], i: ["3", "3"]}}]}, choice_XSDChoiceArrayWithXmlValueXsdChoiceArrayWithXmlValueRecord13_2: {field5: [{value2: {d: ["1"], e: ["2"], f:["3"]}}, {value2: {d: ["1"], e: ["2"], f:["3"]}}], field6: [{value3: {g: ["1"], h: ["2"], i: ["3"]}}]}});
    test:assertEquals(toXml(check v2), xmlValue);

    xmlValue = xml `<Root><field1><b>2</b><b>2</b></field1><field1><a>1</a><b>2</b><c>3</c></field1><field3><h>2</h><i>3</i><i>3</i></field3><field6><g>1</g><h>2</h><i>3</i></field6></Root>`;
    v2 = parseAsType(xmlValue);
    test:assertTrue(v2 is error);
    test:assertEquals((<Error>v2).message(), "'choice_XSDChoiceArrayWithXmlValueXsdChoiceArrayWithXmlValueRecord13_2' occurs less than the min required times");

    xmlValue = xml `<Root><field1><b>2</b><b>2</b></field1><field1><a>1</a><b>2</b><c>3</c></field1><field3><h>2</h><i>3</i><i>3</i></field3><field5><d>1</d></field5><field5><d>1</d><e>2</e><f>3</f></field5><field6><g>1</g><h>2</h><i>3</i></field6></Root>`;
    v2 = parseAsType(xmlValue);
    test:assertTrue(v2 is error);
    test:assertEquals((<Error>v2).message(), "'value2' occurs less than the min required times");
}

@Name {
    value: "Root"
}
type XsdChoiceArrayWithXmlValue5 record {|
    @Choice {
        minOccurs: 2,
        maxOccurs: 3
    }
    Choice_XsdChoiceArrayWithXmlValue5 choice_XsdChoiceArrayWithXmlValue5;
|};

type Choice_XsdChoiceArrayWithXmlValue5 record {|
    int[] age?;
    float[] salary?;
|};

@test:Config {groups: ["xsd", "xsd_choice"]}
function testXsdChoiceArrayWithXmlValue5() returns error? {
    xml xmlValue;
    XsdChoiceArrayWithXmlValue5|Error v;

    xmlValue = xml `<Root><age>13</age><salary>11.1</salary><age>14</age></Root>`;
    v = parseAsType(xmlValue);
    test:assertEquals(v, {choice_XsdChoiceArrayWithXmlValue5: {age: [13, 14], salary: [11.1]}});
    test:assertEquals(toXml(check v), xml `<Root><age>13</age><age>14</age><salary>11.1</salary></Root>`);

    xmlValue = xml `<Root><age>13</age><salary>11.1</salary></Root>`;
    v = parseAsType(xmlValue);
    test:assertEquals(v, {choice_XsdChoiceArrayWithXmlValue5: {age: [13], salary: [11.1]}});
    test:assertEquals(toXml(check v), xmlValue);

    xmlValue = xml `<Root><age>13</age><salary>11.1</salary><age>14</age><salary>14.1</salary><age>15</age><salary>15.1</salary><age>15</age><salary>15.1</salary></Root>`;
    v = parseAsType(xmlValue);
    test:assertTrue(v is Error);
    test:assertEquals((<Error>v).message(), "'choice_XsdChoiceArrayWithXmlValue5' occurs more than the max allowed times");

    xmlValue = xml `<Root><age>13</age></Root>`;
    v = parseAsType(xmlValue);
    test:assertTrue(v is Error);
    test:assertEquals((<Error>v).message(), "'choice_XsdChoiceArrayWithXmlValue5' occurs less than the min required times");
}

@Name {
    value: "Root"
}
type XSDChoiceArrayWithXmlValueXsdChoiceArrayWithXmlValueRecord6 record {
    @Choice {
        minOccurs: 2,
        maxOccurs: 4
    }
    Choice_XSDChoiceArrayWithXmlValueXsdChoiceArrayWithXmlValueRecord6_1 choice_XSDChoiceArrayWithXmlValueXsdChoiceArrayWithXmlValueRecord6_1;

    @Choice {
        minOccurs: 2,
        maxOccurs: 4
    }
    Choice_XSDChoiceArrayWithXmlValueXsdChoiceArrayWithXmlValueRecord6_2 choice_XSDChoiceArrayWithXmlValueXsdChoiceArrayWithXmlValueRecord6_2;
};

type Choice_XSDChoiceArrayWithXmlValueXsdChoiceArrayWithXmlValueRecord6_1 record {
    Choice_Array_A_6[] field1?;
    Choice_Array_B_6[] field2?;
};

type Choice_XSDChoiceArrayWithXmlValueXsdChoiceArrayWithXmlValueRecord6_2 record {
    Choice_Array_D_6[] field4?;
    Choice_Array_E_6[] field5?;
};

@test:Config {groups: ["xsd", "xsd_choice"]}
function testXSDChoiceArrayWithXmlValueXsdChoiceArrayWithXmlValueRecord6() returns error? {
    xml xmlValue = xml `<Root><field1><a>1</a><a>1</a></field1><field2><d>1</d><d>1</d></field2><field1><a>1</a><a>1</a></field1><field2><d>1</d><d>1</d></field2><field4><a>1</a><a>1</a></field4><field5><d>1</d><d>1</d></field5><field4><a>1</a><a>1</a></field4><field5><d>1</d><d>1</d></field5></Root>`;
    XSDChoiceArrayWithXmlValueXsdChoiceArrayWithXmlValueRecord6|Error v2 = parseAsType(xmlValue);
    test:assertEquals(v2, {choice_XSDChoiceArrayWithXmlValueXsdChoiceArrayWithXmlValueRecord6_1: {field1: [{value1: {a: ["1", "1"]}}, {value1: {a:["1", "1"]}}], field2: [{value2: {d: ["1", "1"]}}, {value2: {d: ["1", "1"]}}]}, choice_XSDChoiceArrayWithXmlValueXsdChoiceArrayWithXmlValueRecord6_2: {field4: [{value1: {a: ["1", "1"]}}, {value1: {a:["1", "1"]}}], field5: [{value2: {d: ["1", "1"]}}, {value2: {d: ["1","1"]}}]}});
    test:assertEquals(toXml(check v2), xml `<Root><field1><a>1</a><a>1</a></field1><field1><a>1</a><a>1</a></field1><field2><d>1</d><d>1</d></field2><field2><d>1</d><d>1</d></field2><field4><a>1</a><a>1</a></field4><field4><a>1</a><a>1</a></field4><field5><d>1</d><d>1</d></field5><field5><d>1</d><d>1</d></field5></Root>`);
}
