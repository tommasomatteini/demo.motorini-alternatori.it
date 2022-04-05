package it.motorinialternatori.demo;

import javax.servlet.jsp.tagext.*;
import javax.servlet.jsp.*;
import java.io.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

public class HelloTag extends BodyTagSupport { // SimpleTagSupport
    private String message;

    public void setMessage(String msg) {
        this.message = msg;
    }

    private String exportedArrayVar;
    public String getVar()
    {
        return exportedArrayVar;
    }
    public void setVar(String s)
    {
        exportedArrayVar = s;
    }

    /* kind of magic! */
    public Map<String, Object> data = new HashMap<>();
    public void setData(String name, String value) {
        this.data.put(name, value);
    }

    StringWriter sw = new StringWriter();
    // public void doTag() throws JspException, IOException { // <= se SimpleTagSupport
    @Override
    public int doStartTag() throws JspException {

        String[] outputArray = new String[]{"uno", "due", "pluto"};
        // pageContext.setAttribute(exportedArrayVar, outputArray, PageContext.REQUEST_SCOPE);

        pageContext.setAttribute(exportedArrayVar, this.data, PageContext.REQUEST_SCOPE);


        /*
        ArrayList<String> testo = new ArrayList<>();
        testo.add("aeiou");
        testo.add("bebebebbe");
        pageContext.setAttribute(exportedArrayVar, testo, PageContext.REQUEST_SCOPE);
        */

        if (message != null) {
            /* Use message from attribute */

            // se SimpleTagSupport =>
            // JspWriter out = getJspContext().getOut();
            // out.println( message );


        } else {
            /* use message from the body */

            // se SimpleTagSupport =>
            // getJspBody().invoke(sw);
            // getJspContext().getOut().println(sw.toString());

        }

        return super.doStartTag();
    }



    @Override
    public int doEndTag() throws JspException {


        this.data.forEach((k,v) -> {
            try {
                pageContext.getOut().print(k + ": " +v);
            } catch (IOException e) {
                e.printStackTrace();
            }
        });


        try {
            pageContext.getOut().print(message);
        } catch (IOException e) {
            e.printStackTrace();
        }

        return super.doEndTag();
    }

}
