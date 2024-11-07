package io.ballerina.lib.data.xmldata.xml.xsd;

import io.ballerina.lib.data.xmldata.utils.Constants;
import io.ballerina.runtime.api.types.RecordType;
import io.ballerina.runtime.api.values.BMap;
import io.ballerina.runtime.api.values.BString;

import java.util.HashSet;
import java.util.Set;

public class SequenceInfo implements ModelGroupInfo {
    public String fieldName;
    public long minOccurs;
    public long maxOccurs;
    public int occurrences;

    // TODO: Update to a hashset<String>
    public Set<String> unvisitedElements = new HashSet<>();
    public Set<String> visitedElements = new HashSet<>();
    public Set<String> allElements = new HashSet<>();
    public boolean isCompleted = false;
    public boolean isMiddleOfElement = false;


    public SequenceInfo(String fieldName, BMap<BString, Object> element, RecordType fieldType) {
        this.fieldName = fieldName;
        if (element.containsKey(Constants.MIN_OCCURS)) {
            this.minOccurs = element.getIntValue(Constants.MIN_OCCURS);
        } else {
            this.minOccurs = 1;
        }

        if (element.containsKey(Constants.MAX_OCCURS)) {
            this.maxOccurs = element.getIntValue(Constants.MAX_OCCURS);
        } else {
            this.maxOccurs = Math.max(this.minOccurs, 1);
        }
        this.occurrences = 0;

        // TODO: Name Annotation not encountered
        this.allElements.addAll(fieldType.getFields().keySet());
        this.unvisitedElements.addAll(fieldType.getFields().keySet());
    }

    public void updateOccurrences() {
        this.occurrences++;
        if (this.occurrences > this.maxOccurs) {
            throw new RuntimeException(fieldName + " Element occurs more than the max allowed times");
        }
    }

    public void validateMinOccurrences() {
        if (this.occurrences < this.minOccurs) {
            throw new RuntimeException(fieldName + " Element occurs less than the min required times");
        }
    }

    @Override
    public void validate() {
        if (!isCompleted) {
            throw new RuntimeException("Element " + unvisitedElements.iterator().next() + " not found in " + fieldName);
        }
        validateMinOccurrences();
    }

    @Override
    public void reset() {
        this.unvisitedElements.addAll(allElements);
        this.visitedElements.clear();
    }

    @Override
    public void visit(String element, boolean isStartElement) {
        isMiddleOfElement = isStartElement;
        if (isStartElement) {
            isCompleted = false;
            return;
        }

        if (this.unvisitedElements.contains(element)) {
            isMiddleOfElement = false;
            isCompleted = false;
            this.unvisitedElements.remove(element);
            this.visitedElements.add(element);
            isCompletedSequences(element, false);
            return;
        }
        throw new RuntimeException("Unexpected element " + element + " found in " + fieldName);
    }

    @Override
    public boolean isCompleted() {
        return this.isCompleted;
    }

    @Override
    public boolean isElementContains(String elementName) {
        return this.allElements.contains(elementName);
    }

    @Override
    public boolean isMiddleOfModelGroup() {
        return isMiddleOfElement;
    }

    private void isCompletedSequences(String element, boolean needsUpdate) {
        if (unvisitedElements.isEmpty() && visitedElements.contains(element)) {
            isCompleted = true;
            reset();
            updateOccurrences();
            if (needsUpdate) {
                visitedElements.add(element);
                unvisitedElements.remove(element);
            }
        }
    }
}