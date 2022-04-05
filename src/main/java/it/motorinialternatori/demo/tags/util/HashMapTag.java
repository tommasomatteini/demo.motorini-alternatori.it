package it.motorinialternatori.demo.tags.util;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.PageContext;
import javax.servlet.jsp.tagext.BodyTagSupport;
import java.util.HashMap;
import java.util.Map;

public class HashMapTag extends BodyTagSupport {

    private String var;
    private final Map<String, Object> data = new HashMap<>();

    /**
     *
     * @return ...
     */
    public String getVar() {
        return var;
    }

    /**
     *
     * @param var ...
     */
    public void setVar(String var) {
        this.var = var;
    }

    /**
     *
     * @param key ...
     * @param value ...
     */
    public void setData(String key, Object value) {
        this.data.put(key, value);
    }

    /**
     *
     * @return ...
     * @throws JspException ...
     */
    @Override
    public int doEndTag() throws JspException {
        pageContext.setAttribute(this.var, this.data, PageContext.REQUEST_SCOPE);
        return super.doEndTag();
    }

}
