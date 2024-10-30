package io.ballerina.lib.data.xmldata.xml.xsd;

import io.ballerina.lib.data.xmldata.utils.DiagnosticErrorCode;
import io.ballerina.lib.data.xmldata.utils.DiagnosticLog;

import java.util.HashSet;

public class XsdChoiceInfo implements ModelGroupInfo {
    String id;
    public int occurrence = 0;
    public int maxOccurrences = 1;
    public int minOccurrences = 1;

    public HashSet<String> allChoiceFields = new HashSet<>();

    public XsdChoiceInfo(String id, int minOccurrences, int maxOccurrences) {
        this.id = id;
        this.minOccurrences = minOccurrences;
        this.maxOccurrences = maxOccurrences;
    }

    public void addElementAfterVisit(String choiceMember) {
        updateOccurrence(choiceMember);
    }

    private void updateOccurrence(String choiceMember) {
        if (this.occurrence + 1 > this.maxOccurrences) {
            throw DiagnosticLog.error(DiagnosticErrorCode.XSD_CHOICE_MAX_OCCURENCES_EXCEEDED, choiceMember);
        }
        this.occurrence++;
    }

    public boolean isMember(String choiceElement) {
        return allChoiceFields.contains(choiceElement);
    }

    public void validate() {
        if (this.minOccurrences > this.occurrence) {
            throw DiagnosticLog.error(DiagnosticErrorCode.XSD_CHOICE_MIN_OCCURRENCES_NOT_MET, id);
        }
    }

    @Override
    public void addvisitedModelGroup(String member) {
        addElementAfterVisit(member);
    }

    @Override
    public String getId() {
        return this.id;
    }

    @Override
    public void updateRecentVisitedSequenceOrder(int modelGroupOrder, String fieldName) {
        // ignore
    }
}
