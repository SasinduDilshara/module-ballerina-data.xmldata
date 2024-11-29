/*
 * Copyright (c) 2023, WSO2 LLC. (https://www.wso2.com).
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

package io.ballerina.lib.data.xmldata.utils;

/**
 * Represents a diagnostic error code.
 *
 * @since 0.1.0
 */
public enum DiagnosticErrorCode {

    INVALID_TYPE("XML_ERROR_001", "invalid.type"),
    XML_ROOT_MISSING("XML_ERROR_002", "xml.root.missing"),
    INVALID_REST_TYPE("XML_ERROR_003", "invalid.rest.type"),
    ARRAY_SIZE_MISMATCH("XML_ERROR_004", "array.size.mismatch"),
    REQUIRED_FIELD_NOT_PRESENT("XML_ERROR_005", "required.field.not.present"),
    REQUIRED_ATTRIBUTE_NOT_PRESENT("XML_ERROR_006", "required.attribute.not.present"),
    DUPLICATE_FIELD("XML_ERROR_007", "duplicate.field"),
    FOUND_ARRAY_FOR_NON_ARRAY_TYPE("XML_ERROR_008", "found.array.for.non.array.type"),
    EXPECTED_ANYDATA_OR_JSON("XML_ERROR_009", "expected.anydata.or.json"),
    NAMESPACE_MISMATCH("XML_ERROR_010", "namespace.mismatch"),
    TYPE_NAME_MISMATCH_WITH_XML_ELEMENT("XML_ERROR_011", "type.name.mismatch.with.xml.element"),
    CAN_NOT_READ_STREAM("XML_ERROR_012", "error.cannot.read.stream"),
    CANNOT_CONVERT_TO_EXPECTED_TYPE("XML_ERROR_013", "cannot.convert.to.expected.type"),
    UNSUPPORTED_TYPE("XML_ERROR_014", "unsupported.type"),
    STREAM_BROKEN("XML_ERROR_015", "stream.broken"),
    XML_PARSE_ERROR("XML_ERROR_016", "xml.parse.error"),
    UNDEFINED_FIELD("XML_ERROR_0017", "undefined.field"),
    CANNOT_CONVERT_SOURCE_INTO_EXP_TYPE("XML_ERROR_0018", "cannot.convert.source.into.expected.type"),
    FIELD_CANNOT_CAST_INTO_TYPE("XML_ERROR_0019", "field.cannot.convert.into.type"),
    ELEMENT_OCCURS_MORE_THAN_MAX_ALLOWED_TIMES("XML_ERROR_0020", "element.occurs.more.than.max.allowed.times"),
    ELEMENT_OCCURS_LESS_THAN_MIN_REQUIRED_TIMES("XML_ERROR_0021", "element.occurs.less.than.min.required.times"),
    INVALID_ELEMENT_FOUND("XML_ERROR_0022", "invalid.element.found"),
    REQUIRED_ELEMENT_NOT_FOUND("XML_ERROR_0023", "required.element.not.found"),
    ELEMENT_OCCURS_MORE_THAN_MAX_ALLOWED_TIMES_IN_SEQUENCES(
            "XML_ERROR_0024", "element.occurs.more.than.max.allowed.times.in.sequence"),
    INCORRECT_ELEMENT_ORDER("XML_ERROR_0025", "incorrect.element.order"),
    INVALID_SEQUENCE_ANNOTATION("XML_ERROR_0026", "invalid.sequence.annotation"),
    INVALID_CHOICE_ANNOTATION("XML_ERROR_0027", "invalid.choice.annotation"),
    INVALID_XSD_ANNOTATION("XML_ERROR_0028", "invalid.xsd.annotation"),
    INVALID_XML("XML_ERROR_0029", "invalid.xml"),
    ATTRIBUTE_CANNOT_CONVERT_INTO_ARRAY_TYPE("XML_ERROR_0031",
            "attributes.cannot.convert.to.array.type"),
    CANNOT_CONVERT_ATTRIBUTE_TO_ARRAY_TYPE("XML_ERROR_0032", "cannot.convert.attributes.to.array.type");

    String diagnosticId;
    String messageKey;

    DiagnosticErrorCode(String diagnosticId, String messageKey) {
        this.diagnosticId = diagnosticId;
        this.messageKey = messageKey;
    }

    public String messageKey() {
        return messageKey;
    }
}
