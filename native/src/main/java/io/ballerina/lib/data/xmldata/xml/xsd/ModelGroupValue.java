package io.ballerina.lib.data.xmldata.xml.xsd;

public abstract class ModelGroupValue extends XsdValue {
    private XsdValueType type;

    public ModelGroupValue(XsdValueType xsdValueType) {
        this.type = xsdValueType;
    }
}
