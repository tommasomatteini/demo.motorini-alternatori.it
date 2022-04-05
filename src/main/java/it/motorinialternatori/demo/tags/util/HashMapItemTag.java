package it.motorinialternatori.demo.tags.util;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.SimpleTagSupport;
import java.io.IOException;

public class HashMapItemTag extends SimpleTagSupport {

    private String key;
    private Object value;

    /**
     *
     * @return ...
     */
    public String getKey()
    {
        return this.key;
    }

    /**
     *
     * @param key ...
     */
    public void setKey(String key) {
        this.key = key;
    }

    /**
     *
     * @return ...
     */
    public Object getValue()
    {
        return value;
    }

    /**
     *
     * @param value ...
     */
    public void setValue(Object value)
    {
        this.value = value;
    }

    /**
     *
     * @throws JspException ...
     * @throws IOException ...
     */
    @Override
    public void doTag() throws JspException, IOException {
        HashMapTag parent = (HashMapTag)findAncestorWithClass(this, HashMapTag.class);
        parent.setData(this.key, this.value);
        super.doTag();
    }

}
