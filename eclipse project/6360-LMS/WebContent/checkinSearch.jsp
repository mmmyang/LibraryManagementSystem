<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page errorPage="error.jsp" %>
<%@ page import="java.io.*,java.util.*, javax.servlet.*, java.text.*" %>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>

<!DOCTYPE html>
<html>
  <head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="description" content="Check In Search Page"/>
    <!-- <link rel="icon" href="./img/xxx.ico"> -->
    <title>Library Management System</title>
    
    <!-- Bootstrap core CSS -->
    <link href="http://getbootstrap.com/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- IE10 viewport hack for Surface/desktop Windows 8 bug -->
    <link href="http://getbootstrap.com/assets/css/ie10-viewport-bug-workaround.css" rel="stylesheet">
    
    <script src="http://getbootstrap.com/assets/js/ie-emulation-modes-warning.js"></script>
    <!-- AngularJS -->
    <script src="http://apps.bdimg.com/libs/angular.js/1.4.6/angular.min.js"></script>
    
    <!-- MY CSS -->
    <link href="css/lms.css" rel="stylesheet">
  </head>
  
  <body>
    <!-- HEADER
	================================================== -->
    <div class="container">
      <span class="h1 text-primary">Library Management System</span>
      <img src="images/header.jpg" alt="header" class="pull-right text-bottom"/>
    </div>
    
    <!-- NAVBAR
	================================================== -->
	<div class="container">
	<nav class="navbar navbar-default">
	  <div class="container">
	    <div class="navbar-header">
	      <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target=".navbar-collapse">
	        <span class="sr-only">Toggle navigation</span>
	        <span class="icon-bar"></span>
	        <span class="icon-bar"></span>
	        <span class="icon-bar"></span>
	      </button>
	      <a class="navbar-brand" href="#">LMS</a>
        </div>
        <div class="navbar-collapse collapse">
          <ul class="nav navbar-nav">
            <li><a href="home.jsp">Home</a></li>
            <li><a href="search.jsp">Search</a></li>
            <li><a href="checkout.jsp">Check Out</a></li>
            <li class="active"><a href="checkin.jsp">Check In</a></li>
            <li><a href="cardapply.jsp">Card Apply</a></li>
            <li><a href="fine.jsp">Fine</a></li>
            <li><a href="about.jsp">About</a></li>
          </ul>
        </div><!--/.nav-collapse -->
      </div>
    </nav>
    </div>
    
	<!-- CHECK IN SEARCH
	================================================== -->
	<div class="container">
	<div class="page-header text-primary"><h4 class="text-center">Check In the Book:</h4></div>
	  <form id="ciform" class="form-search" action="checkinSearch.jsp" method="post"  data-ng-app="">
        <span class="col-xs-2">ISBN<input type="text" name="ciisbn" class="form-control" data-ng-model="in1"></input></span>
        <span class="col-xs-2">Card Number<input type="text" name="cicardno" class="form-control" data-ng-model="in2" pattern="[I][D]\d{6}" title="Use the format: IDxxxxxx"></input></span>
        <span class="col-xs-2">Borrower First Name<input type="text" name="cifname" class="form-control" data-ng-model="in3"></input></span>
        <span class="col-xs-2">Borrower Last Name<input type="text" name="cilname" class="form-control" data-ng-model="in4"></input></span>
        <span class="col-xs-2 input-sm"><input id="ci" class="btn btn-lg btn-primary btn-block" type="submit" value="Search" data-ng-disabled="!(in1 || in2 || in3 || in4)"></input></span>
      </form>
	</div>
	
	<!-- CHECK IN 
	================================================== -->
	<div class="container">
	  <br/>
	  <form id="ciform" class="form-search" action="checkinProcess.jsp" method="post"  data-ng-app="">
        <span class="col-xs-2">Loan ID<input type="text" name="ciloanid" class="form-control" data-ng-model="in1"></input></span>
        <span class="col-xs-2 input-sm"><input id="ci" class="btn btn-lg btn-primary btn-block" type="submit" value="Check In" data-ng-disabled="!in1"></input></span>
      </form>
	</div>
    

	<%-- PROCESS CHECK IN SEARCH --%>
	<%! String mysqlpassword = "123"; %>
	<%
		String isbn=request.getParameter("ciisbn");
		String cardNo=request.getParameter("cicardno");
		String fName=request.getParameter("cifname");
		String lName=request.getParameter("cilname");
		if (isbn == null || isbn.equals("")) {
			isbn = "%";
		}
		if (cardNo == null || cardNo.equals("")) {
			cardNo = "%";
		}
		if (fName == null || fName.equals("")) {
			fName = "%";
		} else {
			fName = "%" + fName + "%";
		}
		if (lName == null || lName.equals("")) {
			lName = "%";
		} else {
			lName = "%" + lName + "%";
		}
	
		// use the Library_Management_System library
		String sqlcmd0 = "USE Library_Management_System;";
		String sqlcmd1 = "SELECT BL.Loan_id, BL.Isbn, BL.Branch_id, BL.Card_no, BL.Due_date, BR.Fname, BR.Lname FROM BOOK_LOANS AS BL, BORROWER AS BR WHERE BL.Card_no=BR.Card_no AND BL.Isbn LIKE '" + isbn + "' AND BL.Card_no LIKE '" + cardNo + "' AND BR.Fname LIKE '" + fName + "' AND BR.Lname LIKE '" + lName + "';";
		
		// connect to database
		Class.forName("com.mysql.jdbc.Driver");
		Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/", "root", mysqlpassword);
		Statement stmt1 = conn.createStatement();
		
		stmt1.executeQuery(sqlcmd0);
		ResultSet result1 = stmt1.executeQuery(sqlcmd1);
	%>
	
	<!-- CHECK IN SEARCH RESULT
	================================================== -->
	<div class="container">
	  <div class="page-header text-primary"><h4 class="text-center">Related Books:</h4></div> 
	  <table class="table table-striped">
	    <thead>
		  <tr>
		    <th>Loan ID</th>
		    <th>ISBN</th>
		    <th>Branch ID</th>
		    <th>Card Number</th>
		    <th>Due Date</th>
		    <th>First Name</th>
		    <th>Last Name</th>
		  </tr>
		</thead>
		<tbody>
		<%
			while (result1.next()) {%>
		  <tr>
		    <td><%=result1.getString("Loan_id") %></td>
		    <td><%=result1.getString("Isbn") %></td>
		    <td><%=result1.getString("Branch_id") %></td>
		    <td><%=result1.getString("Card_no") %></td>
		    <td><%=result1.getString("Due_date") %></td>
		    <td><%=result1.getString("Fname") %></td>
		    <td><%=result1.getString("Lname") %></td>
		    <td><button type="submit" value="Check In"></button></td>
		  </tr>
			<% } 
			result1.close();
			conn.close();
		%>
		</tbody>
	  </table>  
	</div> <!-- /.container -->
	
	
	<!-- FOOTER
	================================================== -->
	<div class="container">
      <hr class="featurette-divider"/>
      <footer class="footer">
        <p class="pull-right"><a href="#">Back to top</a></p>
        <span>Library Management System</span>
        <span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
		<em>Design by Fenglan Yang</em>
        <span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
        <%SimpleDateFormat ft = new SimpleDateFormat ("E yyyy.MM.dd"); %>
		<span>Today is <%=ft.format( new Date() )%></span>
      </footer>
    </div> <!-- /.container -->
    
    
  </body>
</html>