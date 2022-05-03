package it.motorinialternatori.demo.tags.cache;

import javax.servlet.jsp.tagext.TagData;
import javax.servlet.jsp.tagext.TagExtraInfo;
import javax.servlet.jsp.tagext.VariableInfo;

public class ResultCacheTei extends TagExtraInfo {

    /**
     *
     * @param tagData ...
     * @return ...
     */
    public VariableInfo[] getVariableInfo(TagData tagData) {
        String exportedVar = (String)tagData.getAttribute("var");
        if (exportedVar != null ) {
            VariableInfo exportedInfo = new VariableInfo(exportedVar, "javax.servlet.jsp.jstl.sql.Result", true, VariableInfo.AT_END);
            return new VariableInfo[] { exportedInfo };
        }
        return new VariableInfo[] {};
    }

}
