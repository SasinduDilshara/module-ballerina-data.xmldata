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

package io.ballerina.stdlib.data.xmldata.xml;

import io.ballerina.runtime.api.Environment;
import io.ballerina.runtime.api.Future;
import io.ballerina.runtime.api.types.MethodType;
import io.ballerina.runtime.api.types.ObjectType;
import io.ballerina.runtime.api.utils.TypeUtils;
import io.ballerina.runtime.api.values.BArray;
import io.ballerina.runtime.api.values.BMap;
import io.ballerina.runtime.api.values.BObject;
import io.ballerina.runtime.api.values.BStream;
import io.ballerina.runtime.api.values.BString;
import io.ballerina.runtime.api.values.BTypedesc;
import io.ballerina.runtime.api.values.BXml;
import io.ballerina.stdlib.data.xmldata.utils.DiagnosticErrorCode;
import io.ballerina.stdlib.data.xmldata.utils.DiagnosticLog;

import java.io.ByteArrayInputStream;
import java.io.InputStreamReader;
import java.io.StringReader;
import java.util.function.Consumer;

/**
 * Xml conversion.
 *
 * @since 0.1.0
 */
public class Native {

    private static final String METHOD_NAME_NEXT = "next";
    private static final String METHOD_NAME_CLOSE = "close";

    public static Object fromXmlWithType(BXml xml, BMap<BString, Object> options, BTypedesc typed) {
        try {
            return XmlTraversal.traverse(xml, typed.getDescribingType());
        } catch (Exception e) {
            return DiagnosticLog.getXmlError(e.getMessage());
        }
    }

    public static Object fromXmlStringWithType(Environment env, Object xml, BMap<BString, Object> map,
                                               BTypedesc typed) {
        try {
            if (xml instanceof BString) {
                return XmlParser.parse(new StringReader(((BString) xml).getValue()), typed.getDescribingType());
            } else if (xml instanceof BArray) {
                byte[] bytes = ((BArray) xml).getBytes();
                return XmlParser.parse(new InputStreamReader(new ByteArrayInputStream(bytes)),
                                       typed.getDescribingType());
            } else if (xml instanceof BStream) {
                final BObject iteratorObj = ((BStream) xml).getIteratorObj();
                final Future future = env.markAsync();
                ResultConsumer<Object> resultConsumer = new ResultConsumer<>(future);
                try (var byteBlockSteam = new BallerinaByteBlockInputStream(env, iteratorObj,
                                                                            resolveNextMethod(iteratorObj),
                                                                            resolveCloseMethod(iteratorObj),
                                                                            resultConsumer)) {
                    Object result = XmlParser.parse(new InputStreamReader(byteBlockSteam), typed.getDescribingType());
                    future.complete(result);
                    return null;
                } catch (Exception e) {
                    future.complete(DiagnosticLog.error(DiagnosticErrorCode.STREAM_BROKEN, e.getMessage()));
                    return null;
                }
            } else {
                return DiagnosticLog.error(DiagnosticErrorCode.UNSUPPORTED_TYPE);
            }
        } catch (Exception e) {
            return DiagnosticLog.error(DiagnosticErrorCode.XML_PARSE_ERROR, e.getMessage());
        }
    }

    static MethodType resolveNextMethod(BObject iterator) {
        MethodType method = getMethodType(iterator, METHOD_NAME_NEXT);
        if (method != null) {
            return method;
        }
        throw new IllegalStateException("next method not found in the iterator object");
    }

    static MethodType resolveCloseMethod(BObject iterator) {
        return getMethodType(iterator, METHOD_NAME_CLOSE);
    }

    private static MethodType getMethodType(BObject iterator, String methodNameClose) {
        ObjectType objectType = (ObjectType) TypeUtils.getReferredType(iterator.getOriginalType());
        MethodType[] methods = objectType.getMethods();
        // Assumes compile-time validation of the iterator object
        for (MethodType method : methods) {
            if (method.getName().equals(methodNameClose)) {
                return method;
            }
        }
        return null;
    }

    /**
     * This class will hold module related utility functions.
     *
     * @param <T>    The type of the result
     * @param future The future to complete
     * @since 0.1.0
     */
    private record ResultConsumer<T>(Future future) implements Consumer<T> {

        @Override
        public void accept(T t) {
            future.complete(t);
        }
    }
}
