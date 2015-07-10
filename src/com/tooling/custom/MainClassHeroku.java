package com.tooling.custom;


import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;

public class MainClassHeroku extends HttpServlet{

	/**
	 * 
	 */

	protected void doPost(HttpServletRequest request, HttpServletResponse response){
		System.out.println("IN SERVLET ");
		
		String userName = request.getParameter("userName").trim();
		String password = request.getParameter("password").trim();
		String environment = request.getParameter("environment").trim();

		System.out.println("input values"+ userName + " " + password + " " +environment );		
		if((userName == null || userName.isEmpty() ) || (password == null || password.isEmpty()) || (environment == null || environment.isEmpty())){
			sendLoginResponse(false, "Please enter valid information", response);
		}else{
			System.out.println("MainClassHeroku>doPost> input data okay");
			try {
				Boolean isProd = false;
				if(DDConstants.ENV_PROD.equals(environment)){
					isProd = true;
				}
				LoginLogic l = new LoginLogic();		
				String result = l.initMethod(userName, password, isProd);			
				//request.getRequestDispatcher("FirstPage.jsp").forward(request,response);
				System.out.println("MainClassHeroku>doPost> result :" + result);
				// If it's success, redirect.
				if(DDConstants.SUCCESS.equals(result)){
					System.out.println("MainClassHeroku>doPost> Going to redirect");
					// response.sendRedirect("/DeloitteForceDesigner/FirstPage.jsp");
					sendLoginResponse(true, "Success", response);
				} else {					
					// Else, send the error response.
					System.out.println("MainClassHeroku> Sending back error message :" + result);
					sendLoginResponse(false, result, response);
				}
				
			} catch (Exception e) {
				System.out.println("MainClassHeroku> Exception :" + e);
				e.printStackTrace();
			}
		}
				
		System.out.println("IN SERVLET END ");
	}
	
	public void sendLoginResponse(Boolean success, String msg, HttpServletResponse response){
		try {
			if(msg == null || response == null){
				throw new Exception("Bad input");
			}
			LoginResponse lr = new LoginResponse();
			lr.setSuccess(success);
			lr.setMsg(msg);
			
			Gson gson = new Gson();
			String jsonResponse = gson.toJson(lr);
			System.out.println("MainClassHeroku>sendLoginResponse>jsonResponse :" + jsonResponse);
			response.setContentType("application/json");
		    response.setCharacterEncoding("UTF-8");		    
			response.getWriter().write(jsonResponse);
		} catch (IOException e) {
			System.out.println("MainClassHeroku>sendLoginResponse> IOException :" + e);
			e.printStackTrace();
		} catch (Exception ex){
			System.out.println("MainClassHeroku>sendLoginResponse> Exception :" + ex);
			ex.printStackTrace();
		}
	}
}
