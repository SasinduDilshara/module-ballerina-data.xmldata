import ballerina/test;
import ballerina/io;

type RootA record {
    @Element {
        form: "qualified"
    }
    string Child1;

    @Element {
        form: "qualified"
    }
    string Child2;
};

@test:Config
function testFormAttributeWithNamespaces() returns error? {
    xml a = xml `<RootA xmlns="http://example.com/ns">
                    <Child1>Value1</Child1>
                    <Child2>Value2</Child2>
                </RootA>`;

    xml b = xml `<a:RootA xmlns:a="http://example.com/ns">
                    <a:Child1>Value1</a:Child1>
                    <a:Child2>Value2</a:Child2>
                </a:RootA>`;

    xml c = xml `<RootA>
                    <Child1>Value1</Child1>
                    <Child2>Value2</Child2>
                </RootA>`;

    xml d = xml `<RootA xmlns:a="http://example.com/ns">
                    <Child1>Value1</Child1>
                    <Child2>Value2</Child2>
                </RootA>`;

    xml e = xml `<a:RootA xmlns:a="http://example.com/ns">
                    <Child1>Value1</Child1>
                    <Child2>Value2</Child2>
                </a:RootA>`;

    xml f = xml `<a:RootA xmlns:a="http://example.com/ns">
            <a:Child1>Value1</a:Child1>
            <Child2>Value2</Child2>
        </a:RootA>`;

    xml g = xml `<a:RootA xmlns:a="http://example.com/ns">
            <Child1>Value1</Child1>
            <a:Child2>Value2</a:Child2>
        </a:RootA>`;

    xml h = xml `<a:RootA xmlns:a="http://example.com/ns">
            <a:Child1>Value1</a:Child1>
            <Child2 xmlns="">Value2</Child2>
        </a:RootA>`;

    xml i = xml `<a:RootA xmlns:a="http://example.com/ns">
            <Child1 xmlns="">Value1</Child1>
            <a:Child2>Value2</a:Child2>
        </a:RootA>`;

    xml j = xml `<RootA xmlns="http://example.com/ns">
            <Child1 xmlns="">Value1</Child1>
            <Child2 xmlns="">Value2</Child2>
        </RootA>`;

    xml k = xml `<RootA xmlns="http://example.com/ns">
                    <Child1 xmlns="">Value1</Child1>
                    <Child2>Value2</Child2>
                </RootA>`;

    RootA|Error r1 = parseAsType(a);
    io:println(r1);

    r1 = parseAsType(b);
    io:println(r1); 

    r1 = parseAsType(c);
    io:println(r1); 

    r1 = parseAsType(d);
    io:println(r1); 

    r1 = parseAsType(e);
    io:println(r1); 

    r1 = parseAsType(f);
    io:println(r1); 

    r1 = parseAsType(g);
    io:println(r1); 

    r1 = parseAsType(h);
    io:println(r1); 

    r1 = parseAsType(i);
    io:println(r1); 

    r1 = parseAsType(j);
    io:println(r1); 

    r1 = parseAsType(k);
    io:println(r1); 
}

