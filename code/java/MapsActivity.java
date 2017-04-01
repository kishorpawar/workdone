package com.matchpointgps.app;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.lang.reflect.Array;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Set;
import java.util.Timer;
import java.util.TimerTask;
import java.util.concurrent.TimeUnit;

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

import android.annotation.SuppressLint;
import android.app.ActionBar;
import android.app.ActionBar.OnNavigationListener;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.SharedPreferences;
import android.content.res.Resources.NotFoundException;
import android.graphics.Color;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentActivity;
import android.support.v4.view.ViewPager;
import android.support.v4.view.ViewPager.OnPageChangeListener;
import android.util.Log;
import android.view.ContextThemeWrapper;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnTouchListener;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.ArrayAdapter;

import com.google.android.gms.maps.CameraUpdate;
import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.GoogleMap.CancelableCallback;
import com.google.android.gms.maps.GoogleMap.OnCameraChangeListener;
import com.google.android.gms.maps.GoogleMap.OnMapClickListener;
import com.google.android.gms.maps.GoogleMap.OnMarkerClickListener;
import com.google.android.gms.maps.MapFragment;
import com.google.android.gms.maps.model.BitmapDescriptor;
import com.google.android.gms.maps.model.BitmapDescriptorFactory;
import com.google.android.gms.maps.model.CameraPosition;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.LatLngBounds;
import com.google.android.gms.maps.model.Marker;
import com.google.android.gms.maps.model.MarkerOptions;
import com.google.android.gms.maps.model.Polyline;
import com.google.android.gms.maps.model.PolylineOptions;
import com.matchpointgps.app.PageFragment.h_layout;
import com.matchpointgps.app.PageFragment.v_layout;
import com.matchpointgps.app.animations.DepthPageTransformer;

/**
 * 
 *
 */
public class MapsActivity extends FragmentActivity implements OnMarkerClickListener,
OnCameraChangeListener, CancelableCallback, OnNavigationListener, OnMapClickListener, OnPageChangeListener
{
	
	private GoogleMap map;
	private String HOST;
	private String locate_url, live_url;
	private PolylineOptions rectOptions = new PolylineOptions();
    private Polyline polyline ;
    
    private List<Polyline> completeLiveTrackPath = new ArrayList<Polyline>();

    private LatLngBounds.Builder live_builder; 
    private Timer live_track = new Timer();
    
    private Marker live_marker;
    
    private static float userZoomLevel = 14;
	private boolean nextCameraChangeIsManual,nextCameraChangedIsAutomatic; 
	
	
	private HashMap<Marker, HashMap<String, String>> markerData = new HashMap<Marker, HashMap<String, String>>();
	private String token, user_id;

	private ProgressDialog progress;
	
	private ViewPager v_pager = null;
	
	/**
	 * On destroying this activity, we need to cancel all timers.
	 * Currently we are cancelling the live_track timer as that is 
	 * the only one that is started.
	 */
	@Override
	protected void onDestroy()
	{
		Log.i("MAP", "On Destroy");
		live_track.cancel();
		super.onDestroy();
		finish();
	}
	
	/**
	 * When this activity is created do the following
	 * <ul>
	 * 	<li> Hide the Action Bar.
	 * 	<li> Get the layout from the xml file and set it for this fragment.
	 * 	<li> Set the map to center to center of India approximately before loading the vehicles.
	 * 	<li> Get the shared preferences for the app and get the stored user id and token.
	 * 	<li> Once the basic map of India is loaded, send a locate request to the server for this account.
	 * 	<li> Set the users location enabled on the map.
	 * </ul>
	 */
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_maps);
		
		map = ((MapFragment) getFragmentManager().findFragmentById(R.id.map))
				.getMap();
		map.setOnCameraChangeListener(this);
		map.setOnMapClickListener(this);
		CameraUpdate cu = CameraUpdateFactory.newLatLngZoom(INDIA_CENTER, COUNTRY_INDIA_ZOOM_LEVEL);
		map.animateCamera(cu,this);
		
		progress = ProgressDialog.show(this, "Loading", "Wait while we load vehicles...");
    	
		HOST = getResources().getString(R.string.HOST);
	    locate_url = getResources().getString(R.string.locate_url);
	    live_url = getResources().getString(R.string.live_url);

	    SharedPreferences shrpre = getSharedPreferences(
	    		getString(R.string.preference_file_key), Context.MODE_PRIVATE);
	    token = shrpre.getString("token_to_send", null);
	    user_id = shrpre.getString("user_id_to_send", null);
	    
		map.setOnMapLoadedCallback(
				new GoogleMap.OnMapLoadedCallback() {
				    public void onMapLoaded() {
				    	ServerResponse locate_response = new ServerResponse();
						locate_response.execute(new String[] {LOCATE, locate_url,
								token, user_id});
				    }
				}
		);
		map.setMyLocationEnabled(true);
	}

	/**
	 * 
	 * @param locate_data
	 */
	@SuppressLint("SimpleDateFormat")
	private void onLocateResponseReceived(JSONArray locate_data) {
		progress.dismiss();

		LatLngBounds.Builder builder = new LatLngBounds.Builder();
		LatLng ltng = null;
		Date event_time = null;
		Boolean ignition = null; 
		Double speed = null;
		HashMap<String, String> tempdict;
		
		ArrayList<String> vehicleList = new ArrayList<String>();
		vehicleList.add("VEHICLES");
		for(int i=0;i<locate_data.length();i++)
		{
			tempdict = new HashMap<String, String>();
			try 
			{
				ignition = (Boolean) locate_data.getJSONObject(i).get(IGNITION_KEY);
				event_time = new SimpleDateFormat(getResources()
							.getString(R.string.DEFAULT_DATE_FORMAT))
							.parse((locate_data.getJSONObject(i).getString(EVENT_TIME_KEY)));
				speed =  locate_data.getJSONObject(i).getDouble(SPEED_KEY);
				
				ltng = new LatLng(locate_data.getJSONObject(i).getDouble(LATITUDE_KEY),
						locate_data.getJSONObject(i).getDouble(LONGITUDE_KEY));
				
				builder.include(ltng);
				
				map.setOnMarkerClickListener(this);
				Marker mark = map.addMarker(new MarkerOptions()
				.position(ltng)
				);

				vehicleList.add(locate_data.getJSONObject(i).get("name").toString());

				tempdict.put(SERIAL_NUMBER_ID_KEY,locate_data.getJSONObject(i).get(SERIAL_NUMBER_ID_KEY).toString());
				tempdict.put(IGNITION_KEY, locate_data.getJSONObject(i).get(IGNITION_KEY).toString());
				tempdict.put("indexAtDropDown", ""+(i+1));
				
				markerData.put(mark,tempdict);
				
				mark.setIcon(getMarkerIcon(event_time, ignition, speed));
			} catch (JSONException e) {
				Log.i("MAP", e.toString());
				e.printStackTrace();
			} catch (ParseException e) {
				Log.i("MAP", e.toString());
				e.printStackTrace();
			}
		}
		
		if(locate_data.length() == 1 && ltng != null)
		{
			CameraUpdate cu = CameraUpdateFactory.newLatLngZoom(ltng, userZoomLevel);
			map.animateCamera(cu,this);
		}
		else 
		{
			LatLngBounds bounds = builder.build();
			CameraUpdate cu = CameraUpdateFactory.newLatLngBounds(bounds, 60);
			map.animateCamera(cu,this);
		}
		
		Context context = new ContextThemeWrapper(this, android.R.style.Theme_Holo);
		
		ArrayAdapter<String> markerAdp = 
				new  ArrayAdapter<String>(context, android.R.layout.simple_spinner_item, android.R.id.text1, vehicleList);
		
		markerAdp.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);

		getActionBar().setNavigationMode(ActionBar.NAVIGATION_MODE_LIST);
		
		getActionBar().setListNavigationCallbacks(markerAdp, this);
	}

	/**
	 * Get the correct marker icon depending on the state of the vehicle.
	 * @param event_time
	 * @param ignition
	 * @param speed
	 * @param mark
	 */
	private BitmapDescriptor getMarkerIcon(Date event_time, Boolean ignition, Double speed) {
		if(getDateDiff(new Date() , event_time, TimeUnit.MINUTES) >= 6)
		{
			return BitmapDescriptorFactory
					.fromResource(R.drawable.ig_no_data);
		}
		else if (ignition == false){
			return BitmapDescriptorFactory
					.fromResource(R.drawable.ig_off);
		} else if(ignition == true && speed == 0 ){
			return BitmapDescriptorFactory
					.fromResource(R.drawable.ig_on_idle);
		}
		else if(ignition == true && speed > 0){
			return BitmapDescriptorFactory
					.fromResource(R.drawable.ig_on_move);
		}
		else{
			return BitmapDescriptorFactory
					.fromResource(R.drawable.ig_no_data);
		}
	}
	
	@Override
	public boolean onMarkerClick(Marker mark) {
		
		nextCameraChangedIsAutomatic = true;
		
		live_marker = mark;
		live_track.cancel();
		
		getActionBar().setSelectedNavigationItem(Integer.parseInt(markerData.get(mark).get("indexAtDropDown")));
		
		rectOptions = new PolylineOptions();
		live_builder = new LatLngBounds.Builder();
		
		final String serial_no_id = markerData.get(mark).get(SERIAL_NUMBER_ID_KEY);
		Boolean ign_state = Boolean.parseBoolean(markerData.get(mark).get(IGNITION_KEY));
		
		Log.i("MAP", "SERIAL NO : " +serial_no_id);
		Log.i("MAP", "IGNITION : " +ign_state);
		
		getLiveTrackData(serial_no_id, ign_state);

		showVerticalOverlay();
		showHorizontalOverlay();
		
		return false;
	}

	/**
	 * 
	 */
	private void showHorizontalOverlay() {
		
		Log.i("ANIMATION", "executing horizontal overlay.");
		List<Fragment> fragments = getHorizontalFragments();
		
		PageAdapter pageAdapter = 
				new PageAdapter(getSupportFragmentManager(), fragments);
		
		ViewPager pager = (ViewPager) findViewById(R.id.h_pager);
		
		pager.setVisibility(View.VISIBLE);
		pager.setPageTransformer(true, new DepthPageTransformer());
		pager.setAdapter(pageAdapter);
		pager.setOnPageChangeListener(this);
		
		pager.setCurrentItem(PageFragment.h_layout.LAYOUT_VEHICLE.getIndex() -1, true);
	}
	
	private void showVerticalOverlay() {
		
		Log.i("ANIMATION", "executing vertical overlay.");
		List<Fragment> v_fragments = getVerticalFragments();
		
		PageAdapter v_pageAdapter = 
				new PageAdapter(getSupportFragmentManager(), v_fragments);
		
		v_pager = (ViewPager) findViewById(R.id.v_pager);
		
		v_pager.setVisibility(View.INVISIBLE);
		v_pager.setScrollContainer(false);
		v_pager.setEnabled(false);
		
		v_pager.setPageTransformer(true, new DepthPageTransformer());
		v_pager.setAdapter(v_pageAdapter);
		
//		v_pager.setRotation(270.0F);
	}
	
	/**
	 * @param serial_no_id
	 * @param ign_state
	 */
	private void getLiveTrackData(final String serial_no_id, Boolean ign_state) {
		if(ign_state == true)
		{	
			if(live_track!=null)
				live_track.cancel();
			
			live_track = new Timer();
			live_track.scheduleAtFixedRate(new TimerTask() {
				@Override
				public void run() {
					ServerResponse live_response = new ServerResponse();
					live_response.execute(new String[] {LIVE_TRACK, live_url,
							token, user_id, serial_no_id});
				}

			}, 0, TEN_SECONDS);
		}
		else {
			if(live_track!=null)
				live_track.cancel();
			live_track = new Timer();
			live_track.scheduleAtFixedRate(new TimerTask() {
				@Override
				public void run() {
					ServerResponse live_response = new ServerResponse();
					live_response.execute(new String[] {LIVE_TRACK, live_url,
							token, user_id, serial_no_id});
				}
			}, 	FIVE_MINUTES, FIVE_MINUTES);
		}
	}


	@SuppressLint("SimpleDateFormat")
	private void drawPolyline(JSONArray live_data) {
		try {
			
			Boolean ignition = Boolean.parseBoolean(live_data.getJSONObject(0).getString(IGNITION_KEY));
			String serial = live_data.getJSONObject(0).getString(SERIAL_NUMBER_ID_KEY);
			Date event_time = new SimpleDateFormat(getResources()
					.getString(R.string.DEFAULT_DATE_FORMAT))
					.parse((live_data.getJSONObject(0).getString(EVENT_TIME_KEY)));
			Double speed = live_data.getJSONObject(0).getDouble(SPEED_KEY);
			
			if(ignition == true)
			{
				if (polyline != null && ! completeLiveTrackPath.isEmpty())
				{
					for(Polyline line : completeLiveTrackPath)
						line.remove();
					completeLiveTrackPath.clear();
				}
				
				LatLng ltln = new LatLng(live_data.getJSONObject(0).getDouble(LATITUDE_KEY),
						live_data.getJSONObject(0).getDouble(LONGITUDE_KEY));
				
				live_marker.setPosition(ltln);
				live_marker.setIcon(getMarkerIcon(event_time, ignition, speed));
				live_builder.include(ltln);
				rectOptions.add(ltln);
				rectOptions.width(2);
				rectOptions.color(Color.RED);

				polyline = map.addPolyline(rectOptions);
				completeLiveTrackPath.add(polyline);
				
				LatLngBounds bounds = live_builder.build();
				
				if( !(nextCameraChangeIsManual) )
				{
					if(polyline.getPoints().size() > MAX_LATLNGS_UNDER_DEFAULT_ZOOM)
					{
						nextCameraChangedIsAutomatic = true;
						CameraUpdate cu = CameraUpdateFactory.newLatLngBounds(bounds, 50);
						map.animateCamera(cu,5000,this);
					}
					else
					{
						Log.i("MAP", "points in else "+ polyline.getPoints());
						nextCameraChangedIsAutomatic = true;
						CameraUpdate cu = CameraUpdateFactory.newLatLngZoom(ltln, userZoomLevel);
						map.animateCamera(cu,500,this);
					}
				}
			}
			else if( ignition == false)
			{
				getLiveTrackData(serial, ignition);
			}
		} catch (JSONException e) {
			e.printStackTrace();
		} catch (NotFoundException e) {
			e.printStackTrace();
		} catch (ParseException e) {
			e.printStackTrace();
		}
	}
	
	private long getDateDiff(Date date1, Date date2, TimeUnit timeUnit) {
	    long diffInMillies = date1.getTime() - date2.getTime();
	    return timeUnit.convert(diffInMillies,TimeUnit.MILLISECONDS);
	}
	
	// #########################################################################
	//     Inner class sub classed from AsyncTask to get data from server.
	// #########################################################################
	/**
	 * An AsyncTask to send an HTTP request to the server and get a response.
	 * 
	 *
	 */
	private class ServerResponse extends AsyncTask<String, Void, JSONArray>
	{
		private String URL, request;
		private HttpResponse response_data; 
		private HttpClient httpclient = new DefaultHttpClient();
		private InputStream ips;
	    private BufferedReader buf;
	    private HttpPost req_url ;
	    private List<NameValuePair> post_data;
	    private JSONArray server_response;
		
	    /**
	     * 
	     */
		@Override
		protected JSONArray doInBackground(String... params) {
	    	
			request = params[0];
			URL = params[1];
			
			if (request.equals(LOCATE))	
			{
	    		req_url = new HttpPost(HOST+URL);
	    		post_data = new ArrayList<NameValuePair>();
	    		post_data.add(new BasicNameValuePair(TOKEN_KEY, params[2]));
	    		post_data.add(new BasicNameValuePair(USER_KEY, params[3]));
			}
			else if (request.equals(LIVE_TRACK))
			{
				req_url = new HttpPost(HOST+URL);
	    		post_data = new ArrayList<NameValuePair>();
	    		post_data.add(new BasicNameValuePair(TOKEN_KEY, params[2]));
	    		post_data.add(new BasicNameValuePair(USER_KEY, params[3]));
	    		post_data.add(new BasicNameValuePair(SERIAL_NUMBER_ID_KEY, params[4]));
			}
			 
			try {
				Log.i("MAP", post_data.toString());
				req_url.setEntity(new UrlEncodedFormEntity(post_data));
				Log.i("MAP", "REQUEST STARTED "+ new Date());
				response_data  = httpclient.execute(req_url);
				ips = response_data.getEntity().getContent();
				Log.i("MAP", "RESPONSE RECEIVED "+ new Date());
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
			
			StringBuilder sb = new StringBuilder();
	        String s = "";
	        while(true)
	        {
	            try {
					s = buf.readLine();
					if(s==null || s.length()==0)
						break;
					sb.append(s);
				} catch (IOException e) {
					e.printStackTrace();
				}
	        }
	        try {
				buf.close();
				ips.close();
				server_response = new JSONArray(sb.toString() );
				
				Log.i("MAP", "RESPONSE " + server_response);
			} catch (IOException e) {
				e.printStackTrace();
			} catch (JSONException e) {
				e.printStackTrace();
			}
			return server_response; 
		}
		
		@Override
	    protected void onPostExecute(JSONArray server_response) 
		{
			if (request.equals(LOCATE))
			{
				if(server_response.length() > 1)
				{
					onLocateResponseReceived(server_response);
				}
				else if(server_response.length() == 1)
				{
					if(progress != null)
						progress.dismiss();
					Boolean ignition = null;
					String serial = null;
					try {
						ignition = Boolean.parseBoolean(server_response.getJSONObject(0).getString(IGNITION_KEY));
						serial = server_response.getJSONObject(0).getString(SERIAL_NUMBER_ID_KEY);
					} catch (JSONException e) {
						e.printStackTrace();
					}
					onLocateResponseReceived(server_response);
					getLiveTrackData(serial, ignition);
				}
			}
			else if(request.equals(LIVE_TRACK))
			{
				drawPolyline(server_response);
			}
		}
	}

	@Override
	public void onCameraChange(CameraPosition position) {
		if (nextCameraChangeIsManual) {
			// User caused onCameraChange...
			userZoomLevel = position.zoom;
			Log.i("MAP", "On camera change isManual to true");
			nextCameraChangedIsAutomatic = false;
		} else if(nextCameraChangeIsManual == false && nextCameraChangedIsAutomatic == false){
			// The next map move will be caused by user, unless we
			// do another move programmatically
			Log.i("MAP", "On camera change isManual to false");
			nextCameraChangeIsManual = true;
			
			// onCameraChange caused by program...
		}
		else if(nextCameraChangeIsManual == true && nextCameraChangedIsAutomatic == true){
			Log.i("MAP", "On camera changd isManual to false");
			nextCameraChangeIsManual = false;
		}
		else if(nextCameraChangeIsManual == false && nextCameraChangedIsAutomatic == true){
			Log.i("MAP", "On camera change isManual to false");
			nextCameraChangeIsManual = false;
			nextCameraChangedIsAutomatic = false;
		}
	}
 
	@Override
	public void onCancel() {
		Log.i("MAP", "On Cancel changing isManual to true");
		nextCameraChangeIsManual = true;
	}

	@Override
	public void onFinish() {
		Log.i("MAP", "On Finish changing isManual to false");
		nextCameraChangeIsManual = false;
	}
	
//	private int getColor()
//	{
//		Random rand = new Random();
//		
//		int r = rand.nextInt(150) + 5;
//		int g = rand.nextInt(250) + 5;
//		int b = rand.nextInt(180) + 5;
//		
//		return  Color.rgb(r, g, b);
//	}

	@Override
	public boolean onNavigationItemSelected(int itemPosition, long itemId) {

		Set<Marker> keys = markerData.keySet();
		for(Marker m: keys)
		{
			if(Integer.parseInt(markerData.get(m).get("indexAtDropDown")) == itemPosition)
			{
				CameraUpdate cu = CameraUpdateFactory.newLatLngZoom(m.getPosition(), userZoomLevel);
				map.animateCamera(cu, this);
				Log.i("MAP", m.getTitle() + ":" + markerData.get(m).get(SERIAL_NUMBER_ID_KEY));
				onMarkerClick(m);
			}
		}
		return false;
	}

	private List<Fragment> getHorizontalFragments() {

		List<Fragment> fragList = new ArrayList<Fragment>();
			
		for( h_layout layout : Arrays.asList( PageFragment.h_layout.values()))
		{
			Fragment pageFragment = PageFragment.newInstance(
						layout.getIndex(), getApplicationContext(), v_pager);
			fragList.add(pageFragment);
		}
		
		return fragList;
	}
	
	private List<Fragment> getVerticalFragments() {

		List<Fragment> fragList = new ArrayList<Fragment>();
		
		for( v_layout layout : Arrays.asList( PageFragment.v_layout.values()))
		{
			Fragment pageFragment = PageFragment.newInstance(
							layout.getIndex(), getApplicationContext(), v_pager);
			fragList.add(pageFragment);
		}
		
		return fragList;
	}

	@Override
	public void onMapClick(LatLng arg0) {
		// TODO Auto-generated method stub
		Log.i("MAP", "MAP CLICKED");

		View h_pagerView = findViewById(R.id.h_pager); 
		View v_pagerView = findViewById(R.id.v_pager);
		h_pagerView.setVisibility(View.INVISIBLE);
		v_pagerView.setVisibility(View.INVISIBLE);
		
	}
	
	private final static LatLng INDIA_CENTER = new LatLng(23.30, 80.00);
	private final static int COUNTRY_INDIA_ZOOM_LEVEL = 4;
	private final static String LOCATE = "locate";
	private final static String LIVE_TRACK = "live";
	private static final String SPEED_KEY = "speed";
	private static final String EVENT_TIME_KEY = "event_time";
	private static final String SERIAL_NUMBER_ID_KEY = "serial_number_id";
	private static final String IGNITION_KEY = "ignition_state";
	private static final String LATITUDE_KEY = "latitude";
	private static final String LONGITUDE_KEY = "longitude";
	private static final String TOKEN_KEY = "token";
	private static final String USER_KEY = "user";
	private static final int TEN_SECONDS = 10000;
	private static final int FIVE_MINUTES = 30000;
	private static final int MAX_LATLNGS_UNDER_DEFAULT_ZOOM = 5;
//	private static final float MIN_SLIDE_UP = -15;
//	private static final float MIN_SLIDE_DOWN = 70;

	@Override
	public void onPageScrollStateChanged(int arg0) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void onPageScrolled(int position, float offset, int offsetPixels) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void onPageSelected(int arg0) {
		// TODO Auto-generated method stub
		if(v_pager.getVisibility() == View.VISIBLE)
		{
			Animation slideDown = AnimationUtils.loadAnimation(getApplicationContext(), R.animator.slide_down);
			v_pager.startAnimation(slideDown);
			v_pager.setVisibility(View.INVISIBLE);
		} 
	}

}