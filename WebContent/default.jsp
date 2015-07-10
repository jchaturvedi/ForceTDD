<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
      
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<script type="text/javascript" src="js/jquery.min.js"></script>

<script type="text/javascript" src="js/flat-ui.js"></script>
<script type="text/javascript" src="js/bootstrap-select.js"></script>

<link type="text/css" href="css/bootstrap.min.css" rel="stylesheet">
<link type="text/css" href="css/flat-ui.css" rel="stylesheet">
<link type="text/css" href="css/bootstrap-select.css" rel="stylesheet">


<script>

    $(document).ready(function() {
    	$('.selectpicker').selectpicker();

    	$('#submit').click(function() {
            $.ajax({
            	type: "POST", 
                url : 'MainClassHeroku',
                data : {
                    userName : $('#loginname').val(),
            		password : $('#loginpass').val(),
            		environment : $("select#environment").val()
                },
                success : function(responseText) {
                    $('#welcometext').text(responseText);
                }
            });
        });
    	
});
    
</script>

<style type="text/css">
#welcometext{
	text-shadow: 0px 1px 1px #4d4d4d;
	color: #FF0000;
	font: 15px 'MisoRegular';
}
</style>


<title>Insert title here</title>
</head>

<body>

<form  name="frmAddUser" class="login-screen"  id="myform">
			
			<div class="login">

			<div class="login-form">
			
			<div class="form-group">
              <input type="text" class="form-control login-field" value="" placeholder="Enter Your Salesforce Username" id="loginname" name="userid">
            </div>
            
			<div class="form-group">
              <input type="password" class="form-control login-field" value="" placeholder="Salesforce Password+Token" id="loginpass" name="pwd">
            </div>
			
			<div class="form-group">
			<select class="selectpicker form-control"  name="environment" id="environment">
			    <option value="">Environment</option>
			    <option value="Production">Production</option>
			    <option value="Sandbox">Sandbox</option>
			  </select>
			</div>

		<div class="form-group" id="welcometext">
		</div>
							
<br> <br>
		<div class="form-group">
			<button type="button" class="btn btn-primary btn-lg btn-block" id="submit" >Log in</button>
			</div>
		
		
		
	</div>
		</div>	

</form>

</body>
</html>