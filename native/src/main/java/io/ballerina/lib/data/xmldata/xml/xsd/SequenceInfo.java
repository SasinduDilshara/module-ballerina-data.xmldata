/*
 * Copyright (c) 2024, WSO2 LLC. (https://www.wso2.com).
 *
 * WSO2 LLC. licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package io.ballerina.lib.data.xmldata.xml.xsd;

import io.ballerina.lib.data.xmldata.utils.Constants;
import io.ballerina.lib.data.xmldata.utils.DataUtils;
import io.ballerina.lib.data.xmldata.utils.DiagnosticErrorCode;
import io.ballerina.lib.data.xmldata.utils.DiagnosticLog;
import io.ballerina.runtime.api.types.RecordType;
import io.ballerina.runtime.api.values.BMap;
import io.ballerina.runtime.api.values.BString;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Stack;

/**
 * Represent xsd sequence.
 *
 * @since 1.1.0
 */
public class SequenceInfo implements ModelGroupInfo {
    public String fieldName;
    public long minOccurs;
    public long maxOccurs;
    public int occurrences;
    private final Map<String, Integer> remainingElementCount = new HashMap<>();
    private final Map<String, Integer> minimumElementCount = new HashMap<>();
    private final Map<String, Integer> maxElementCount = new HashMap<>();
    private final Map<String, Boolean> elementOptionality = new HashMap<>();
    private final List<String> allElements = new ArrayList<>();
    int currentIndex = 0;
    int elementCount;
    String lastElement = "";
    private boolean isCompleted = false;
    private boolean isMiddleOfElement = false;
    private final Stack<HashMap<String, ElementInfo>> xmlElementInfo;
    private HashMap<String, String> xmlElementNameMap = new HashMap<>();

    public SequenceInfo(String fieldName, BMap<BString, Object> element, RecordType fieldType,
                        Stack<HashMap<String, ElementInfo>> xmlElementInfo) {
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
        this.xmlElementInfo = xmlElementInfo;
        updateUnvisitedElementsBasedOnPriorityOrder(fieldType);
        this.xmlElementNameMap = DataUtils.getXmlElementNameMap(fieldType);
        reOrderElementNamesBasedOnTheNameAnnotation();
        this.elementCount = allElements.size();
    }

    public void updateOccurrences() {
        this.occurrences++;
        if (this.occurrences > this.maxOccurs) {
            throw DiagnosticLog.error(DiagnosticErrorCode.ELEMENT_OCCURS_MORE_THAN_MAX_ALLOWED_TIMES, fieldName);
        }
    }

    public void validateMinOccurrences() {
        if (this.occurrences < this.minOccurs) {
            throw DiagnosticLog.error(DiagnosticErrorCode.ELEMENT_OCCURS_LESS_THAN_MIN_REQUIRED_TIMES, fieldName);
        }
    }

    @Override
    public void validate() {
        generateElementOptionalityMapIfNotPresent();
        validateCompletedSequences();
        reset();
    }

    private void reset() {
        this.isCompleted = false;
        this.isMiddleOfElement = false;
        this.currentIndex = 0;
        this.remainingElementCount.putAll(this.maxElementCount);
        this.lastElement = "";
    }

    @Override
    public void visit(String element, boolean isStartElement) {
        generateElementOptionalityMapIfNotPresent();
        if (isMiddleOfElement && isStartElement) {
            return;
        }

        isMiddleOfElement = isStartElement;
        if (isStartElement) {
            isCompleted = false;
            return;
        }

        checkElementOrderAndUpdateElementOccurences(element);
    }

    @Override
    public boolean isElementContains(String elementName) {
        return this.allElements.contains(elementName);
    }

    @Override
    public boolean isMiddleOfModelGroup() {
        return isMiddleOfElement;
    }

    @Override
    public boolean predictStartNewModelGroup(String element) {
        generateElementOptionalityMapIfNotPresent();
        if (!isElementContains(element)) {
            return false;
        }

        boolean isFirstElement = element.equals(allElements.get(0));
        if (isFirstElement && currentIndex == 0 && remainingElementCount.get(allElements.get(0)) > 0) {
            return false;
        }

        return !isMiddleOfElement && isFirstElement
                && (isCompleted || containsAllOptionalElements())
                && !(lastElement.equals(element) && remainingElementCount.get(element) > 0);
    }

    private void validateCompletedSequences() {
        if (!isCompleted && !containsAllOptionalElements()) {
            throw DiagnosticLog.error(DiagnosticErrorCode
                    .REQUIRED_ELEMENT_NOT_FOUND, getUnvisitedElements(), fieldName);
        }
        updateOccurrences();
    }

    private boolean containsAllOptionalElements() {
        for (int i = currentIndex; i < this.elementCount; i++) {
            if (!elementOptionality.get(allElements.get(i))) {
                return false;
            }
        }
        return true;
    }

    private void checkElementOrderAndUpdateElementOccurences(String element) {
        String nextElement;
        boolean isLastElement = false;

        if (element.equals(lastElement)) {
            nextElement = lastElement;
            isLastElement = true;
        } else {
            nextElement = allElements.get(currentIndex == this.elementCount ? currentIndex - 1 : currentIndex);
        }

        while (!nextElement.equals(element)) {
            if (!elementOptionality.get(nextElement)) {
                throw DiagnosticLog.error(DiagnosticErrorCode.INCORRECT_ELEMENT_ORDER,
                        xmlElementNameMap.get(element), fieldName);
            }
            currentIndex++;
            nextElement = allElements.get(currentIndex);

            if (currentIndex == this.elementCount) {
                throw DiagnosticLog.error(DiagnosticErrorCode.INCORRECT_ELEMENT_ORDER,
                        xmlElementNameMap.get(element), fieldName);
            }
        }

        if (remainingElementCount.get(nextElement) == 0) {
            throw DiagnosticLog.error(DiagnosticErrorCode.ELEMENT_OCCURS_MORE_THAN_MAX_ALLOWED_TIMES_IN_SEQUENCES,
                    xmlElementNameMap.get(nextElement), fieldName);
        } else {
            remainingElementCount.put(element, remainingElementCount.get(nextElement) - 1);
            int elementCount = maxElementCount.get(element) - remainingElementCount.get(element);

            if (elementCount >= minimumElementCount.get(element) && !isLastElement
                    && currentIndex != this.elementCount) {
                currentIndex++;
            } else {
                if (elementCount == 1) {
                    currentIndex++;
                }
            }

            if (currentIndex == this.elementCount && elementCount >= minimumElementCount.get(element)) {
                isCompleted = true;
            }
        }
        lastElement = nextElement;
    }

    private String getUnvisitedElements() {
        StringBuilder unvisitedElementsStr = new StringBuilder();
        allElements.subList(currentIndex, this.elementCount).forEach(element -> {
            if (!elementOptionality.get(element)) {
                unvisitedElementsStr.append(xmlElementNameMap.get(element)).append(", ");
            }
        });
        String result = unvisitedElementsStr.toString();
        result = result.substring(0, result.length() - 2);
        return result;
    }

    private void updateUnvisitedElementsBasedOnPriorityOrder(RecordType fieldType) {
        this.allElements.addAll(DataUtils.getXsdSequencePriorityOrder(fieldType, true).entrySet().stream()
                .sorted(Map.Entry.comparingByValue())
                .map(Map.Entry::getKey)
                .toList());

        this.currentIndex = 0;
    }

    private void generateElementOptionalityMapIfNotPresent() {
        if (elementOptionality.isEmpty()) {
            if (!xmlElementInfo.isEmpty()) {
                allElements.forEach(element -> {
                    HashMap<String, ElementInfo> elementInfo = xmlElementInfo.peek();
                    if (elementInfo.containsKey(element)) {
                        ElementInfo info = elementInfo.get(element);
                        elementOptionality.put(element, info.minOccurs == 0);
                        remainingElementCount.put(element, (int) info.maxOccurs);
                        maxElementCount.put(element, (int) info.maxOccurs);
                        minimumElementCount.put(element, (int) info.minOccurs);
                    } else {
                        elementOptionality.put(element, false);
                        remainingElementCount.put(element, 1);
                        maxElementCount.put(element, 1);
                        minimumElementCount.put(element, 1);
                    }
                });
            } else {
                allElements.forEach(element -> {
                    elementOptionality.put(element, false);
                    remainingElementCount.put(element, 1);
                    maxElementCount.put(element, 1);
                    minimumElementCount.put(element, 1);
                });
            }
        }
    }

    private void reOrderElementNamesBasedOnTheNameAnnotation() {
        xmlElementNameMap.forEach((key, value) -> {
            if (allElements.contains(value)) {
                allElements.set(allElements.indexOf(value), key);
            }
        });
        allElements.forEach(element -> {
            if (!xmlElementNameMap.containsKey(element)) {
                xmlElementNameMap.put(element, element);
            }
        });
    }
}
