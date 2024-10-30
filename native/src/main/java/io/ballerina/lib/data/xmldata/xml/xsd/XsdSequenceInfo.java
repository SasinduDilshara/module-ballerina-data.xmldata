package io.ballerina.lib.data.xmldata.xml.xsd;

import io.ballerina.lib.data.xmldata.utils.DiagnosticErrorCode;
import io.ballerina.lib.data.xmldata.utils.DiagnosticLog;

import java.util.HashSet;

public class XsdSequenceInfo implements ModelGroupInfo {
    public String id;
    public HashSet<String> allSequenceFields = new HashSet<>();
    public HashSet<String> visitedSequenceFields = new HashSet<>();
    public HashSet<String> nonVisitedSequenceFields = new HashSet<>();
    public int occurrence = 0;
    public int maxOccurrences;
    public int minOccurrences;
    public int recentVisitedSequenceOrder = -1;

    public boolean isCompletelyVisited = false;

    public XsdSequenceInfo(String id, int minOccurrences, int maxOccurrences, String sequenceElement) {
        this.id = id;
        this.minOccurrences = minOccurrences;
        this.maxOccurrences = maxOccurrences;
        updateNonVisitedSequenceFields(sequenceElement);
    }

    public void updateSequenceFieldsAfterVisit(String sequenceElement) {
        visitedSequenceFields.add(sequenceElement);
        nonVisitedSequenceFields.remove(sequenceElement);
        resetSequenceFieldsIfAllAreVisited(sequenceElement);
    }

    public void updateNonVisitedSequenceFields(String sequenceElement) {
        isCompletelyVisited = false;
        allSequenceFields.add(sequenceElement);
        nonVisitedSequenceFields.add(sequenceElement);
    }

    public void updateRecentVisitedSequenceOrder(int sequenceOrder, String sequenceElement) {
        if (sequenceOrder <= this.recentVisitedSequenceOrder) {
            throw DiagnosticLog.error(DiagnosticErrorCode.XSD_INVALID_SEQUENCE_ORDER, sequenceElement);
        }
        recentVisitedSequenceOrder = sequenceOrder;
    }

    private void resetSequenceFieldsIfAllAreVisited(String sequenceElement) {
        if (nonVisitedSequenceFields.isEmpty()) {
            nonVisitedSequenceFields.addAll(visitedSequenceFields);
            visitedSequenceFields.clear();
            updateOccurrence(sequenceElement);
            this.recentVisitedSequenceOrder = -1;
            isCompletelyVisited = true;
            return;
        }
        isCompletelyVisited = false;
    }

    private void updateOccurrence(String sequenceElement) {
        if (this.occurrence + 1 > this.maxOccurrences) {
            throw DiagnosticLog.error(DiagnosticErrorCode.XSD_MAX_OCCURENCES_EXCEEDED, sequenceElement);
        }
        occurrence++;
    }

    public boolean isMember(String sequenceElement) {
        return allSequenceFields.contains(sequenceElement);
    }

    public void validate() {
        if (this.minOccurrences > this.occurrence) {
            throw DiagnosticLog.error(DiagnosticErrorCode.XSD_MIN_OCCURRENCES_NOT_MET, id);
        }
        if (this.maxOccurrences > 0 && !this.isCompletelyVisited) {
            throw DiagnosticLog.error(
                    DiagnosticErrorCode.XSD_INCOMPLETE_SEQUENCE,
                    String.join(", ", this.nonVisitedSequenceFields));
        }
    }

    @Override
    public void addvisitedModelGroup(String member) {
        updateSequenceFieldsAfterVisit(member);
    }

    @Override
    public String getId() {
        return this.id;
    }
}
