package it.motorinialternatori.demo.tags.cache;

import com.github.benmanes.caffeine.cache.Cache;
import com.github.benmanes.caffeine.cache.Caffeine;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.PageContext;
import javax.servlet.jsp.jstl.sql.Result;
import javax.servlet.jsp.tagext.BodyTagSupport;
import java.util.concurrent.TimeUnit;

public class ResultCacheTag extends BodyTagSupport {

    Cache<String, Result> cache;

    private String name = null;
    private String var = null;

    private int duration = 60*60;

    private int size = 10000;

    private String cache_name = "result_cache_tag";

    private Result value = null;

    /**
     *
     * @param lang ...
     */
    public void setLang(String lang) {
        this.name = this.name + "__" + lang;
    }

    /**
     *
     * @param group ...
     */
    public void setGroup(String group) {
        this.cache_name = this.cache_name + "__" + group;
    }

    /**
     *
     * @param size ...
     */
    public void setSize(int size) {
        this.size = size;
    }

    /**
     *
     * @param duration ...
     */
    public void setDuration(int duration) {
        this.duration = duration;
    }

    /**
     *
     * @param name ...
     */
    public void setName(String name) {
        this.name = name;
    }

    /**
     *
     * @return ...
     */
    public String getVar() {
        return this.var;
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
     * @param value ...
     */
    public void setValue(Result value) {
        this.value = value;
    }

    /**
     *
     * @return ...
     */
    @Override
    public int doStartTag() throws JspException {
        this.cache = (Cache)pageContext.getAttribute(this.cache_name, PageContext.APPLICATION_SCOPE);
        if (this.cache == null) {
            this.cache = Caffeine.newBuilder()
                    .expireAfterWrite(this.duration, TimeUnit.SECONDS)
                    .maximumSize(this.size)
                    .build();
            pageContext.setAttribute(this.cache_name, this.cache, PageContext.APPLICATION_SCOPE);
        }
        if (this.name != null) {
            if (this.var == null && this.value != null) {
                this.cache.put(this.name, this.value);
            } else {
                Result payload = this.cache.getIfPresent(this.name);
                pageContext.setAttribute(this.var, payload, PageContext.PAGE_SCOPE);
            }
        }
        return SKIP_BODY;
    }

}
