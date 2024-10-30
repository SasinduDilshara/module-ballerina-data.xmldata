package io.ballerina.lib.data.xmldata.xml.xsd;

import io.ballerina.lib.data.xmldata.utils.Constants;
import io.ballerina.runtime.api.values.BMap;
import io.ballerina.runtime.api.values.BString;

public class ModelGroupChoiceValue extends ModelGroupValue {
    public int minOccurs = 1;
    public int maxOccurs = 1;
    public String id;

    public ModelGroupChoiceValue(BMap<BString, Object> value) {
        super(XsdValueType.CHOICE);
        this.id = ((BString) value.get(Constants.ID)).getValue();
        if (value.containsKey(Constants.MIN_OCCURS)) {
            this.minOccurs = ((Long) value.get(Constants.MIN_OCCURS)).intValue();
        }

        if (value.containsKey(Constants.MAX_OCCURS)) {
            this.maxOccurs = ((Long) value.get(Constants.MAX_OCCURS)).intValue();
        } else {
            this.maxOccurs = Math.max(1, this.minOccurs);
        }
    }
}
