package it.motorinialternatori.demo.tags.util;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.PageContext;
import javax.servlet.jsp.tagext.BodyTagSupport;
import java.util.LinkedHashMap;

public class HashMapTag extends BodyTagSupport {

    private String var;
    private LinkedHashMap<String, Object> data = null;

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
     */
    public LinkedHashMap<String, Object> getData() {
        return this.data;
    }

    /**
     *
     * @return ...
     * @throws JspException ...
     */
    @Override
    public int doStartTag() throws JspException {
        this.data = new LinkedHashMap<>();
        return super.doStartTag();
    }

    /**
     *
     * @return ...
     * @throws JspException ...
     */
    @Override
    public int doEndTag() throws JspException {
        pageContext.setAttribute(this.var, this.data.clone(), PageContext.REQUEST_SCOPE);
        return super.doEndTag();
    }

}
