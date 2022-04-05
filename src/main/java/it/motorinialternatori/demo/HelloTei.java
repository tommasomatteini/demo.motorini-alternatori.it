package it.motorinialternatori.demo;

import javax.servlet.jsp.tagext.TagData;
import javax.servlet.jsp.tagext.TagExtraInfo;
import javax.servlet.jsp.tagext.VariableInfo;

public class HelloTei extends TagExtraInfo {
    public VariableInfo[] getVariableInfo(TagData tagData)
    {
        String exportedArrayVar = (String) tagData.getAttribute("var");
        VariableInfo exportedArrayInfo = new VariableInfo(exportedArrayVar,
                "java.util.HashMap",
                true,
                VariableInfo.AT_END);

        return new VariableInfo[] {exportedArrayInfo};
    }
}