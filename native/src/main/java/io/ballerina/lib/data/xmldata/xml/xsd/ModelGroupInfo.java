package io.ballerina.lib.data.xmldata.xml.xsd;

public interface ModelGroupInfo {
    boolean isMember(String member);

    void validate();

    void addvisitedModelGroup(String member);

    String getId();

    void updateRecentVisitedSequenceOrder(int modelGroupOrder, String fieldName);
}
