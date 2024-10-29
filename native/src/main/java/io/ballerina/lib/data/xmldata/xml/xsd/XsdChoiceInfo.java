package io.ballerina.lib.data.xmldata.xml.xsd;

import io.ballerina.lib.data.xmldata.utils.DiagnosticErrorCode;
import io.ballerina.lib.data.xmldata.utils.DiagnosticLog;

public class XsdChoiceInfo {
    public int occurrence = 0;
    public int maxOccurrences = 1;
    public int minOccurrences = 1;

    public XsdChoiceInfo(int minOccurrences, int maxOccurrences) {
        this.minOccurrences = minOccurrences;
        this.maxOccurrences = maxOccurrences;
    }

    public void addElementAfterVisit(String fieldName) {
        updateOccurrence(fieldName);
    }

    private void updateOccurrence(String fieldName) {
        if (this.occurrence + 1 > this.maxOccurrences) {
            throw DiagnosticLog.error(DiagnosticErrorCode.XSD_CHOICE_MAX_OCCURENCES_EXCEEDED, fieldName);
        }
        occurrence++;
    }
}
