package com.matchpointgps.app;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.List;

import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GooglePlayServicesUtil;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.DialogInterface.OnClickListener;
import android.content.Intent;
import android.content.SharedPreferences;
import android.net.ConnectivityManager;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.EditText;

public class LoginActivity extends Activity {

	String HOST, login_url;
	final String USER_ID_TO_SEND = "user_id_to_send";
	final String token_TO_SEND = "token_to_send";
	
	ProgressDialog progress;
	
	int IS_GOOGLE_PLAY_AVAILABLE;
	public boolean isOnline() {
		ConnectivityManager cm =
				(ConnectivityManager) getSystemService(Context.CONNECTIVITY_SERVICE);
		
		return cm.getActiveNetworkInfo() != null && 
				cm.getActiveNetworkInfo().isConnectedOrConnecting();
	}
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
	    IS_GOOGLE_PLAY_AVAILABLE = GooglePlayServicesUtil.isGooglePlayServicesAvailable(this);
		getActionBar().hide();
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_login);
		
		SharedPreferences shrpre = getSharedPreferences(
				getString(R.string.preference_file_key), Context.MODE_PRIVATE);
		
		String token = shrpre.getString("token_to_send", null);
		Log.i("MAP", "TOKEN "+ token);
		goToActivity(token, false);
	}

	/**
	 * @param token, status
	 */
	private void goToActivity(String token, Boolean status) {
		
		Log.i("MAP", "STATUS AND TOKEN at outer level " + status+":"+token);
		if (IS_GOOGLE_PLAY_AVAILABLE == ConnectionResult.SUCCESS)
		{
			if((!(token == "" || token == null)) || status == true)
			{
				Log.i("MAP", "STATUS AND TOKEN" + status+":"+token);
				Intent intent_Maps = new Intent(this, MapsActivity.class);
				startActivity(intent_Maps);
				
				if (progress != null)
					progress.dismiss();
				finish();
			}
		}
		else
		{
			 Log.i("MAP", "GOOGLE PLAY IS NOT AVAILABLE");
			 GooglePlayServicesUtil.getErrorDialog(IS_GOOGLE_PLAY_AVAILABLE, this, IS_GOOGLE_PLAY_AVAILABLE);
		}
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		getMenuInflater().inflate(R.menu.login, menu);
		return true;
	}

	public boolean onOptionsItemSelected(MenuItem item) {
		int id = item.getItemId();
		if (id == R.id.action_settings) {
			return true;
		}
		return super.onOptionsItemSelected(item);
	}
	
	public void getAuthenticated(View view) {
		EditText username, password;
		
		username = (EditText) findViewById(R.id.email_address);
		password = (EditText) findViewById(R.id.password);
		HOST = getResources().getString(R.string.HOST);
	    login_url = getResources().getString(R.string.login_url);
		
		Log.i("MAP", "LET ME GET YOU AUTHENTICATED "+ username.getText().toString() );
		
		ServerResponse authuser = new ServerResponse();
		authuser.execute(new String[] {"auth", login_url,
		username.getText().toString(),
		password.getText().toString()});
		
		progress = ProgressDialog.show(this, "Loading", "Wait while we know who you are...");
		
		
	}
	
	// #########################################################################
	//     Inner class to be subclassed from AsyncTask to get data from server.
	// #########################################################################
	
	private class ServerResponse extends AsyncTask<String, Void, JSONArray>
	{
		String URL, response;
		HttpResponse response_data; 
		HttpClient httpclient = new DefaultHttpClient();
		InputStream ips;
	    BufferedReader buf;
	    HttpPost req_url ;
	    List<NameValuePair> post_data;
	    JSONArray server_response;
		
		@Override
		protected JSONArray doInBackground(String... params) {
			response = params[0];
			URL = params[1];
			
			if (response == "auth" )
			{
				req_url = new HttpPost(HOST+URL);
				
				post_data = new ArrayList<NameValuePair>();
				post_data.add(new BasicNameValuePair("username",params[2]));
				post_data.add(new BasicNameValuePair("password", params[3]));
			}
			 
			try {
				Log.i("MAP", post_data.toString());
				req_url.setEntity(new UrlEncodedFormEntity(post_data));
				response_data  = httpclient.execute(req_url);
				ips = response_data.getEntity().getContent();
				buf = new BufferedReader(new InputStreamReader(ips,"UTF-8"));
			} 
			catch (UnsupportedEncodingException e1) {
				e1.printStackTrace();
			}
			catch (ClientProtocolException e) {
				e.printStackTrace();
			} 
			catch (IOException e) {
				e.printStackTrace();
			}
			catch (IllegalStateException e) {
				e.printStackTrace();
			}
			
			JSONArray sb = new JSONArray();
	        String s = "";
	        while(true )
	        {
	            try {
					s = buf.readLine();
					if(s==null || s.length()==0)
						break;
					sb.put(new JSONObject(s));
				} catch (IOException e) {
					e.printStackTrace();
				} catch (JSONException e) {
					e.printStackTrace();
				}

	        }
	        try {
				buf.close();
				ips.close();
				Log.i("MAP", "STRING RES " + sb.toString());
				server_response = sb;
				Log.i("MAP", "RESpOnSe " + server_response);
			} catch (IOException e) {
				e.printStackTrace();
			}
	        
			return server_response; 
		}
		
		@Override
	    protected void onPostExecute(JSONArray server_response) {
			
			Boolean status = false;
			
			SharedPreferences sharedPref = getSharedPreferences(
			        getString(R.string.preference_file_key), Context.MODE_PRIVATE);
			
			SharedPreferences.Editor editor = sharedPref.edit();
			try {
				Log.i("MAP", "AUTH RESPONSE : "+ server_response.getJSONObject(0));
				status = server_response.getJSONObject(0).getBoolean("success");

				Log.i("MAP", "STATUS "+ status);
				
				if (status == true ){
					editor.putString(USER_ID_TO_SEND, 
							server_response.getJSONObject(0).getString("user").toString());
					editor.putString(token_TO_SEND, 
							server_response.getJSONObject(0).getString("token").toString());
					editor.commit();
					
					goToActivity("", status);
				}
				else
				{
					new AlertDialog.Builder(LoginActivity.this)
				    	.setTitle("Login Failed!")
				    	.setMessage("Please Check your username and password.")
				    	.setCancelable(true)
				    	.setPositiveButton("ok", new OnClickListener() {
				    		@Override
				    		public void onClick(DialogInterface dialog, int which) {
				    		}
				       }).create().show();
					progress.dismiss();
				}
			} catch (JSONException e) {
				e.printStackTrace();
			}
		}
		
	}
}
