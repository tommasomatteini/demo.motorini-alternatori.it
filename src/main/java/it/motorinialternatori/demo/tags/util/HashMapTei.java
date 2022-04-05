package it.motorinialternatori.demo.tags.util;

import javax.servlet.jsp.tagext.TagData;
import javax.servlet.jsp.tagext.TagExtraInfo;
import javax.servlet.jsp.tagext.VariableInfo;

/**
 *
 */
public class HashMapTei extends TagExtraInfo {

    /**
     *
     * @param tagData ...
     * @return ...
     */
    public VariableInfo[] getVariableInfo(TagData tagData) {
        String exportedVar = (String)tagData.getAttribute("var");
        VariableInfo exportedInfo = new VariableInfo(exportedVar, "java.util.HashMap", true, VariableInfo.AT_END);
        return new VariableInfo[] { exportedInfo };
    }

}
