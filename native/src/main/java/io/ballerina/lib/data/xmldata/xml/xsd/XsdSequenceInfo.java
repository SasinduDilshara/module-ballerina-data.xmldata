package io.ballerina.lib.data.xmldata.xml.xsd;

import io.ballerina.lib.data.xmldata.utils.DiagnosticErrorCode;
import io.ballerina.lib.data.xmldata.utils.DiagnosticLog;

import java.util.HashSet;

public class XsdSequenceInfo {
    public HashSet<String> visitedSequenceFields = new HashSet<>();
    public HashSet<String> nonVisitedSequenceFields = new HashSet<>();
    public int occurrence = 0;
    public int maxOccurrences = 1;
    public int minOccurrences = 1;
    public int recentVisitedSequenceOrder = -1;

    public boolean isCompletelyVisited = false;

    public XsdSequenceInfo(int minOccurrences, int maxOccurrences, String fieldName) {
        this.minOccurrences = minOccurrences;
        this.maxOccurrences = maxOccurrences;
        updateNonVisitedSequenceFields(fieldName);
    }

    public void updateSequenceFieldsAfterVisit(String fieldName) {
        visitedSequenceFields.add(fieldName);
        nonVisitedSequenceFields.remove(fieldName);
        resetSequenceFieldsIfAllAreVisited(fieldName);
    }

    public void updateNonVisitedSequenceFields(String fieldName) {
        isCompletelyVisited = false;
        nonVisitedSequenceFields.add(fieldName);
    }

    public void updateRecentVisitedSequenceOrder(int sequenceOrder, String fieldName) {
        if (sequenceOrder <= this.recentVisitedSequenceOrder) {
            throw DiagnosticLog.error(DiagnosticErrorCode.XSD_INVALID_SEQUENCE_ORDER, fieldName);
        }
        recentVisitedSequenceOrder = sequenceOrder;
    }

    private void resetSequenceFieldsIfAllAreVisited(String fieldName) {
        if (nonVisitedSequenceFields.isEmpty()) {
            nonVisitedSequenceFields.addAll(visitedSequenceFields);
            visitedSequenceFields.clear();
            updateOccurrence(fieldName);
            this.recentVisitedSequenceOrder = -1;
            isCompletelyVisited = true;
            return;
        }
        isCompletelyVisited = false;
    }

    private void updateOccurrence(String fieldName) {
        if (this.occurrence + 1 > this.maxOccurrences) {
            throw DiagnosticLog.error(DiagnosticErrorCode.XSD_MAX_OCCURENCES_EXCEEDED, fieldName);
        }
        occurrence++;
    }
}
