package it.motorinialternatori.demo;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.SimpleTagSupport;
import java.io.IOException;

public class HelloItemTag extends SimpleTagSupport {

    private String name;
    public String getName()
    {
        return name;
    }
    public void setName(String s)
    {
        name = s;
    }

    private String value;
    public String getValue()
    {
        return value;
    }
    public void setValue(String s)
    {
        value = s;
    }

    @Override
    public void doTag() throws JspException, IOException {
        HelloTag parent = (HelloTag) findAncestorWithClass(this, HelloTag.class);
        parent.setData(this.name, this.value);
        super.doTag();
    }
}
