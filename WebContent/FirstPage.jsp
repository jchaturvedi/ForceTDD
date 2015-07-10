<%@ page language="java" contentType="text/html; charset=ISO-8859-1"  pageEncoding="ISO-8859-1"%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<script type="text/javascript" src="js/jquery.js"></script>
	<script type="text/javascript" src="js/bootstrap-datepicker.js"></script>
	<script type="text/javascript" src="js/jquery.dataTables.js"></script>
	<script type="text/javascript" src="js/jquery-check-all.min.js"></script>
	<script type="text/javascript" src="js/bootstrap.js"></script>
		<script type="text/javascript" src="js/jquery.multi-select.js"></script>

	<link type="text/css" href="css/bootstrap-datepicker.css" rel="stylesheet">
	<link type="text/css" href="css/font-awesome.min.css" rel="stylesheet">
	<link type="text/css" href="css/jquery-ui.css" rel="stylesheet">
	<link type="text/css" href="css/demo_table_jui.css" rel="stylesheet">
	<link type="text/css" href="css/bootstrap.min.css" rel="stylesheet">
		<link type="text/css" href="css/multi-select.css" rel="stylesheet">

	<title>Insert title here</title>

	<style type="text/css">
			.tftable {border-width: 1px;border-color: #ccc;border-collapse: collapse;border-spacing:0;}
			.tftable th {font-family:Tahoma, sans-serif;font-size:12px;background-color:#E5E4E2;border-width: 1px;padding: 5px;border-style: solid;border-color: #a9a9a9;text-align:left;}
			.tftable tr {background-color:#fff;}
			.tftable td {font-family:Tahoma, sans-serif;font-size:11px;border-width: 1px;padding: 3px;border-style: solid;border-color: #EEEEEE;}
			.tftable tr:hover {background-color:#EBF4FA;}

			body{background:#fff;}

			.datecustom{
				padding: 6px 1px 1px 6px;
				border: 2px solid #337ab7;
				width: 400px;
				display: block;
				font-size: 14px;
				height: 35px;
				background-color: #fff;
				border-radius: 4px;
				box-shadow: inset 0px 1px 1px rgba(0,0,0,0.075);
				font-family: "Lato", Helvetica, Arial, sans-serif;
			}

			.btn { background:#0C6; }

			.box {
				position: relative;
				-webkit-box-shadow: 0px 0px 0px rgba(0,0,0,.5);
				-moz-box-shadow: 0px 0px 0px rgba(0,0,0,.5);
				box-shadow: 0px 0px 0px rgba(0,0,0,.5); 
				/* Kokakify */
				padding: 1px;
				background: #F7F7F7;
				border-color:#337ab7;
				border: 1px solid transparent #306EFF;
				//border-radius:4px;
			}
			
			.letterpress{
				color: #000;
				font-size:16px;
				font-weight: bold;
				font-family: 'Source Sans Pro', sans-serif;
			}
			
			.btncustom{height:40px; border:none; background:#0C6; width:100%; outline:none; font-family: 'Source Sans Pro', sans-serif; font-size:20px; font-weight:bold; color:#eee; border-bottom:solid 3px #093; border-radius:0px; cursor:pointer}
	</style>



	<script>

		$(document).ready(function() {
		       
			$('#component').multiSelect({ keepOrder: true
			});
			
			$('#select-all').click(function(){
				  $('#component').multiSelect('select_all');
				  return false;
				});
				$('#deselect-all').click(function(){
				  $('#component').multiSelect('deselect_all');
				  return false;
				});
				
			document.getElementById("welcometext").style.display = "none";
			document.getElementById("panelid").style.display = "none";
			$('#datepicker').datepicker();
			
			$('#add').click(function() {  
				!$('#users option:selected').remove().appendTo('#selecteduser');
			   $("#selecteduser").html($('#selecteduser option').sort(function(x, y) {
					 return $(x).text() < $(y).text() ? -1 : 1;
			   }));
			 });  
			 $('#remove').click(function() {  
			   !$('#selecteduser option:selected').remove().appendTo('#users'); 
			   $("#users").html($('#users option').sort(function(x, y) {
					 return $(x).text() < $(y).text() ? -1 : 1;
			   }));
			 });
			 
			 $('#add2').click(function() {  
				!$('#component option:selected').remove().appendTo('#selectedcomponents'); 
				 $("#selectedcomponents").html($('#selectedcomponents option').sort(function(x, y) {
					 return $(x).text() < $(y).text() ? -1 : 1;
				}));
			 });  
			 $('#remove2').click(function() {  
					 !$('#selectedcomponents option:selected').remove().appendTo('#component'); 
					$("#component").html($('#component option').sort(function(x, y) {
						 return $(x).text() < $(y).text() ? -1 : 1;
					}));
			 });
					
			$.ajax({
				type: "POST", 
				url : 'FirstPageClass',
				data : {
					action : "fetchuserlist"
				},
				success : function(responseText) {
					var $select = $('#users'); 
					$.each(responseText, function(key, value) {               
						$('<option>').val(key).text(value).appendTo($select);      
						 });
							$("#users").html($('#users option').sort(function(x, y) {
							 return $(x).text() < $(y).text() ? -1 : 1;
							 }));
							document.getElementById("welcometext").style.display = "inline";
				}
			});
			
			$('#submit').click(function() {
				var countries = [];
				$.each($("#component option:selected"), function(){            
					countries.push($(this).val());
				});
				var compostring =  countries.join(",");
				alert("You have selected - " + compostring);
				
				var userlist = [];
				$.each($("#selecteduser option:selected"), function(){            
					userlist.push($(this).val());
				});
				var userstring =  userlist.join(",");
				
				$.ajax({
					type: "POST", 
					url : 'FirstPageClass',
					data : {
						action : "fetchcomplist",
						componentlist : compostring,
						userlist : userstring
					},
					dataType: 'json',
					success : function(responseText) {
						var counter = 1;
						$.each(responseText.apexclasslist, function() {
						   $('#apextable').append('<tr><td> <input type="checkbox" id="apexcheck" name="apexcheck" class="checkbox1" value=" ' +  this['id'] + ' "/> </td><td>'+ this['fullName'] +'</td><td>' + this['status'] +  '</td></tr>');
						   counter = counter + 1;
						 });
						$('#apextable').dataTable({
							"bJQueryUI": true,
							"sPaginationType": "full_numbers",
							"jQueryUI": false,
							"bSortable": true,              	       
							"aoColumnDefs": [  { 'bSortable': false, "width": "2%", 'aTargets': [ 0 ] } ],               	        
							});
						$('#apexcheck1').checkAll();
						document.getElementById("panelid").style.display = "inline";
					}
				});
			});  
			  
			
			
	});
	</script>
</head>

<body  >
	<form action="FirstPageClass" method="post">

	<br>
	<div class="box">
	<label class="letterpress"> User:</label>
	</div>
	<div id="welcometext" > 
		<table class="example" border=0>
			<tr>
				<td>
					<select id="users" multiple="multiple" name="usernames">
					</select>
				</td>
				<td>
					<a href="#" id="add">add </a> 
				</td>
				<td>
					<a href="#" id="remove">remove </a> 
				</td>
				<td>
					<select multiple="multiple" id="selecteduser" name="selectedusernames"></select>  
				</td>
			</tr>
		</table>
	</div>

	<br><br>
	<div >
		<label class="letterpress"> Component List:</label>
		<div id="components" > 
			<table class="example" border=0>
				<tr>
					<td>
						<select id="component" multiple="multiple"  name="usernames">
						<option value="apexclass"> Apex Classes </option>
						<option value="apextrigger"> Apex Triggers </option>
						<option value="vfpage">Visualforce Pages </option>
						<option value="workflowrule">Workflow Rules</option>
						<option value="customsetting">Custom Setting</option>
						</select>
					</td>
					<td>
						<a href='#' id='select-all'>Select All</a>
						<a href='#' id='deselect-all'>Deselect All</a> 
					</td>
				</tr>
			</table>
		</div>  
	</div> 

	<br><br>
	<div class="box">
		<label class="letterpress"> Date:</label>
	</div>
	<div>
		<input id="datepicker" class="datecustom"/>
	</div>

	<br><br>
	<button type="button" class="btncustom" id="submit" >Fetch The Component List</button>

	<br><br>

<button type="submit" class="btncustom" id="generate" >Generate</button>

<div id="panelid">
			<ul id="myTab" class="nav nav-tabs">
			   <li class="active"><a href="#apexclass" data-toggle="tab">
			      Apex Classes</a>
			   </li>
			   <li><a href="#trigger" data-toggle="tab">Triggers</a></li>
			   <li><a href="#java" data-toggle="tab">VF Pages</a></li>
			</ul>
			
			
			<div id="myTabContent" class="tab-content">
			   <div class="tab-pane fade in active" id="apexclass">
					
					<table id="apextable" class=" datatable tftable  display ">
					<thead>
					<tr>
					<th> <input type="checkbox" id="apexcheck1" name="apexcheck1" /> </th>
					<th> Class Name </th>
					<th> Class Status </th>
					</tr>
					</thead>
					<tbody>
					</tbody>
					</table>
			
			   </div>
			   <div class="tab-pane fade" id="trigger">
			   <table id="triggertable" class=" datatable tftable  display ">
					<thead>
					<tr>
					<th> <input type="checkbox" id="apexcheck2" name="apexcheck2" /> </th>
					<th> Trigger Name </th>
					<th> Trigger Status </th>
					</tr>
					</thead>
					<tbody>
					</tbody>
					</table>
			   </div>
			</div>
</div>

	</form>
</body>
</html>