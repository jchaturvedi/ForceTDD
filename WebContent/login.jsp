<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en-us">
    <meta charset="utf-8" />
    <head>
        <title>Salesforce DeloitteForce Designer</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link type="text/css" href="css/font-awesome.min.css" rel="stylesheet">
        <link type="text/css" href="css/bootstrap.min.css" rel="stylesheet">
        <script type="text/javascript" src="js/jquery.js"></script>
        <style type="text/css">
            @font-face {
              font-family: "Frutiger Next Pro Light";
              src: url('fonts/FrutigerNextPro-Light.otf');
            }
            @font-face {
              font-family: "Frutiger Next Pro Medium";
              src: url('fonts/FrutigerNextPro-Medium.otf');
            }
            @font-face {
              font-family: "Frutiger Next Pro Bold";
              src: url('fonts/FrutigerNextPro-Bold.otf');
            }
            /*
             * General styles
             */
            body, html {
                height: 100%;
                background-repeat: no-repeat;
                font-family: 'Frutiger Next Pro Light', sans-serif;
            }

            .header-content{
                font-family: 'Frutiger Next Pro Bold', sans-serif;
                margin-top: 20px;                
            }
            
            .header-content h1{
            	text-align: center;
            }

            .card-container.card {
                max-width: 450px;
                padding: 40px 40px;
            }

            .btn {
                font-family: 'Frutiger Next Pro Medium', sans-serif;
                -moz-user-select: none;
                -webkit-user-select: none;
                user-select: none;
                cursor: default;
            }

            /*
             * Card component
             */
            .card {
                background-color: #F7F7F7;
                /* just in case there no content*/
                padding: 20px 25px 30px 25px;
                margin: 0 auto;
                margin-top: 5%;
                /* shadows and rounded borders */
                -moz-border-radius: 2px;
                -webkit-border-radius: 2px;
                border-radius: 2px;
                -moz-box-shadow: 0px 2px 2px rgba(0, 0, 0, 0.3);
                -webkit-box-shadow: 0px 2px 2px rgba(0, 0, 0, 0.3);
                box-shadow: 0px 2px 2px rgba(0, 0, 0, 0.3);
            }

            .profile-img-card {
                width: 250px;
                /*height: 96px;*/
                margin: 0 auto 10px;
                display: block;
            }

            /*
             * Form styles
             */
            .profile-name-card {
                font-size: 16px;
                font-weight: bold;
                text-align: center;
                margin: 10px 0 0;
                min-height: 1em;
            }

            .reauth-email {
                display: block;
                color: #404040;
                line-height: 2;
                margin-bottom: 10px;
                font-size: 14px;
                text-align: center;
                overflow: hidden;
                text-overflow: ellipsis;
                white-space: nowrap;
                -moz-box-sizing: border-box;
                -webkit-box-sizing: border-box;
                box-sizing: border-box;
            }

            .form-signin #inputLogin,
            .form-signin #inputPassword,
            .form-signin #inputEnvironment {
                direction: ltr;
                height: 44px;
                font-size: 16px;
            }

            .form-signin input[type=email],
            .form-signin input[type=password],
            .form-signin input[type=text],
            .form-signin select,
            .form-signin button {
                width: 100%;
                display: block;
                margin-bottom: 10px;
                z-index: 1;
                position: relative;
                -moz-box-sizing: border-box;
                -webkit-box-sizing: border-box;
                box-sizing: border-box;
            }

            .form-signin .form-control:focus {
                border-color: rgb(104, 145, 162);
                outline: 0;
                -webkit-box-shadow: inset 0 1px 1px rgba(0,0,0,.075),0 0 8px rgb(104, 145, 162);
                box-shadow: inset 0 1px 1px rgba(0,0,0,.075),0 0 8px rgb(104, 145, 162);
            }

            /*.btn.btn-signin {
                background-color: rgb(104, 145, 162);
                padding: 0px;
                font-weight: 700;
                font-size: 14px;
                height: 36px;
                -moz-border-radius: 3px;
                -webkit-border-radius: 3px;
                border-radius: 3px;
                border: none;
                -o-transition: all 0.218s;
                -moz-transition: all 0.218s;
                -webkit-transition: all 0.218s;
                transition: all 0.218s;
            }*/

            .btn.btn-signin:hover,
            .btn.btn-signin:active,
            .btn.btn-signin:focus {
                background-color: #000000;
            }
        </style>
    </head>
    <body>
        <header>
            <div class="header-content">
				<h1>Deloitte ForceDesigner</h1>
            </div>
        </header>
        <div class="container">
            <div class="card card-container">
                <img id="profile-img" class="profile-img-card" src="img/DD_RGB_white-black.png" />
                <p id="profile-name" class="profile-name-card"></p>
                <form class="form-signin">
                    <span id="reauth-email" class="reauth-email"></span>
                    <input type="text" id="inputLogin" class="form-control" placeholder="Salesforce User Name" required autofocus>
                    <input type="password" id="inputPassword" class="form-control" placeholder="Password" required>
                    <select  id="inputEnvironment" class="form-control" required>
                        <option value="">&nbsp; --Login Environment--</option>
                        <option value="Production">Production</option>
                        <option value="Sandbox">Sandbox</option>
                    </select>
                    <button class="btn btn-lg btn-primary btn-block btn-signin" type="submit" id="submitBtn">Log in</button>
                    <div id="response-msg" class="alert alert-danger" style="display:none;"></div>
                </form><!-- /form -->
            </div><!-- /card-container -->
        </div><!-- /container -->


        <script type="text/javascript" src="js/jquery.min.js"></script>
        <script type="text/javascript" src="js/bootstrap.min.js"></script>
        <script type="text/javascript">
            var j$ = jQuery.noConflict();
            j$(document).ready(function() {
                j$('.form-signin').submit(function(ev) {
                	ev.preventDefault();
                	j$('#response-msg').hide();
                    // j$('.form-signin').submit();
                    j$.ajax({
                        type: "POST",
                        url : 'MainClassHeroku',
                        data : {
                                userName : j$('#inputLogin').val(),
                                password : j$('#inputPassword').val(),
                                environment : j$('#inputEnvironment').val()
                        },
                        success : function(response) {
                            if(response.success == true){
                                window.location.replace('/HerokuProject/FirstPage.jsp');
                            }else{
                                j$('#response-msg').text(response.msg);
                                j$('#response-msg').show();
                            } 
                        }
                    });
                });       
            });
        
        </script>
    </body>
</html>