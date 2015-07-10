package com.tooling.custom;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import com.google.gson.Gson;
import com.sforce.soap.tooling.ApexClass;
import com.sforce.soap.tooling.QueryResult;
import com.sforce.soap.tooling.SObject;
import com.sforce.ws.ConnectionException;
import com.sforce.soap.tooling.User;

public class FirstPageClass extends HttpServlet {
	
	
	public void doPost(HttpServletRequest request, HttpServletResponse response){
		try {	
			String[] idsToDelete = request.getParameterValues("apexcheck");
			String userName = request.getParameter("action");

			if(userName != null && userName.equals("fetchuserlist")){
				//LoginLogic l = new LoginLogic();
				//String result = l.initMethod("j.chaturvedi@89demo.com", "nam51726jhusvh7L788xZ0qkpw2YI3fQN", true);
				System.out.println("In First Class"); 
				
				//if(result.equals("Success")){
					com.sforce.soap.tooling.QueryResult userTemLIst = LoginLogic.toolingConnection.query("SELECT Id, Name FROM User LIMIT 100");
					List<User> userList = new ArrayList<User>();
					Map<String, String> userNameList = new HashMap<String, String>(); 
					
					SObject[] userClassList = userTemLIst.getRecords();
					for(int i = 0; i < userClassList.length; ++i){
						User classRecord = (User) userClassList[i];
						userList.add(classRecord);
					}				
					for(User a : userList){
						userNameList.put(a.getId(), a.getName());
					}					
					String json = null;
					json = new Gson().toJson(userNameList);					
					System.out.println("input values"+ json);
					response.setContentType("application/json");
					response.setCharacterEncoding("UTF-8");
					try {
						response.getWriter().write(json);
					} catch (Exception e) {
						e.printStackTrace();
					}
				//}	
			}
			System.out.println("outside if");
			
			if((userName != null && userName.equals("fetchcomplist"))){
								
				String compolist = request.getParameter("componentlist");
				Map<String, String> componentList = new HashMap<String, String>();
				for(String s : compolist.split(",")){
					componentList.put(s, s);
				}			
				System.out.println("componentList values"+ componentList);
				
				if(!componentList.isEmpty()){
					String apexclass = null;
					if(componentList.keySet().contains("apexclass")){
						apexclass = componentList.get("apexclass");
					}
					
					if( apexclass != null && apexclass.equals("apexclass") ){
						QueryResult classList = null;
						try {
							classList = LoginLogic.toolingConnection.query("SELECT Id, Name, Status, FullName, LastModifiedDate, LastModifiedById FROM ApexClass");
							List<ApexClass> apexClassFinalList = new ArrayList<ApexClass>();
							List<ApexClass> apexClassFinalList2 = new ArrayList<ApexClass>();
							SObject[] apexClassList = classList.getRecords();
							for(int i = 0; i < apexClassList.length; ++i){
								ApexClass classRecord = (ApexClass) apexClassList[i];
								apexClassFinalList.add(classRecord);
							}
							
							for(ApexClass a : apexClassFinalList){
								apexClassFinalList2.add(a);
							}
							try {				
								JSONObject json = new JSONObject();	
								json.accumulate("apexclasslist", apexClassFinalList2);
								System.out.println("input values"+ json.toString());
								response.setContentType("json");
								response.setCharacterEncoding("UTF-8");
								response.getWriter().write(json.toString());
							} catch (IOException e) {
								e.printStackTrace();
							}
						} catch (ConnectionException e) {
							e.printStackTrace();
						}
						System.out.println("QueryResult SIZE:--- "+ classList.getSize());
					}
				}			
			}
			
			
			if(idsToDelete != null && idsToDelete.length > 0){						
				List<String> idset = new ArrayList<String>();		
				if(idsToDelete != null){
					for (int i = 0; i < idsToDelete.length; i++) {
						System.out.println("ID Value" + idsToDelete[i] + "<br>");
						idset.add(idsToDelete[i].trim());						
					}
				}
				String s= quoteKeySet(idset);				
				LoginLogic l = new LoginLogic();
				String[] s1 = new String[idset.size()];
				//System.out.println("idset.toArray(new String[idset.size()])--- "+ (String[]) idset.toArray());
			
				for(int i=0; i< idset.size(); i++){
					s1[i] = idset.get(i);
				}
				System.out.println("idset.toArray(new String[idset.size()])--- "+ s1);
				l.fetchApexClassMethod(s);
			}
						
		} catch (ConnectionException e) {
			e.printStackTrace();
		}
		
		
	}
	
	 private String quoteKeySet(List<String> mapKeySet)
	    {
	        String newSetStr = ""  ;
	        for(String str : mapKeySet)
	            newSetStr += "'" + str + "',";

	        newSetStr = newSetStr.lastIndexOf(',') > 0 ? '(' + newSetStr.substring(0,newSetStr.lastIndexOf(',')) + ')' : newSetStr ;
	        System.out.println("newSetStr result:--- "+ newSetStr);
	        return newSetStr;

	    }
}
