<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/core/commons.jspf" %>
<%@ include file="/WEB-INF/core/sql.jspf" %>
<%@ include file="/WEB-INF/core/routes.jspf" %>
<%@ taglib prefix="custom" uri="/WEB-INF/tlds/custom.tld"%>
<%@ taglib prefix="utils" uri="/WEB-INF/tlds/utils.tld" %>

<!DOCTYPE html>
<html>
<body>

<fmt:message key="slogan" var="test_slogan"/><br/>

<custom:Hello message="pluto" var="test">
    <custom:HelloItem name="Prima" value="${test_slogan}" />
    <custom:HelloItem name="Secondo" value="Test" />
</custom:Hello>

<c:forEach items="${test}" var="item" varStatus="loop">
    <pre>${item}</pre>
</c:forEach>

</body>
</html>