package pkg.locate;

import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.net.SocketException;
import java.net.UnknownHostException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.TimeZone;

import android.app.AlertDialog;
import android.app.IntentService;
import android.content.Context;
import android.content.Intent;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.provider.Settings;
import android.telephony.TelephonyManager;
import android.util.Log;
import android.widget.EditText;

public class Loservice extends IntentService {
	
	final static String MAINLOG = "servicemain";
	
	private static long MIN_TIME = 300000; // 5 minutes in microseconds

	@Override
	protected void onHandleIntent(Intent arg0) {
//	 	enableGPS();	
//		getLocateDataFromAndroid();
		String Data = getLocateData();
		send_gps_data(Data);
//		Log.i(MAINLOG, "Stop service "+stopService(arg0));
//		System.gc();
	}
	
	public Loservice() {
	 	   super("Loservice");
	}
 
		
	public Location getLocateDataFromAndroid(){
		float bestAccuracy = 200.0f; 
		long curtime = new Date().getTime();
		long bestTime = (curtime - MIN_TIME);
		
		LocationManager locationManager = (LocationManager) getSystemService(Context.LOCATION_SERVICE); 
		Location bestResult = null;
		List<String> matchingProviders = locationManager.getAllProviders();
//		Log.i(MAINLOG, matchingProviders.toString());
		
		for (String provider: matchingProviders) {
			Log.i(MAINLOG, provider);
			Location location = null;
			try{
//				location = locationManager.getLastKnownLocation(provider);
				location = locationManager.requestLocationUpdates(provider, MIN_TIME, 1, this);
			}
			catch (Exception e) {
				Log.i(MAINLOG, "Exception: "+e.toString());
			}
			if (location != null) {
			    float accuracy = location.getAccuracy();
			    long time = location.getTime();
			    long preTime = time; 
	
			    Log.i(MAINLOG,"ACCURACY "+accuracy);
			    Log.i(MAINLOG,"BEST ACC "+bestAccuracy);
			    if ((time > bestTime && accuracy < bestAccuracy)) {
			    	Log.i(MAINLOG, "matched");
			    	bestResult = location;
			    	bestAccuracy = accuracy;
			    	bestTime = time;
			    }
			    else if(time < bestTime && time >= preTime){
			    	bestResult = location;
			    }
		  }else{
			  Log.e(MAINLOG, "LOCATION is null");
		  }
		}
		return bestResult;
	}
	
	public String getLocateData() {
		String Data = "";
		LocationManager lm = (LocationManager) getSystemService(Context.LOCATION_SERVICE);
		TelephonyManager tMgr =(TelephonyManager) getSystemService(Context.TELEPHONY_SERVICE);

		String deviceID = tMgr.getDeviceId();
		Log.i(MAINLOG, "DEVICE ID "+deviceID);
		Location loc = getLocateDataFromAndroid();

		if(loc==null){
			Log.wtf(MAINLOG, "Location object is null");
			return Data;
		}
//
//		if (netloc != null)
//		{
//			loc = netloc;	
//		}
		
		Date date = new Date(loc.getTime());
		Date now = new Date();
		
		Log.i(MAINLOG, "Date  "+date.getTime());
		Log.i(MAINLOG, "NOW  "+now.getTime());
		
		float locAge = (float) (now.getTime() - date.getTime())/(1000*60); // locAge saving in minutes.
		Log.i(MAINLOG, "LOCAGE  "+locAge);
		
		SimpleDateFormat sdf = new SimpleDateFormat("M/dd/yyyy hh:mm:ss", Locale.ENGLISH);
		sdf.setTimeZone(TimeZone.getTimeZone("UTC"));
		String formattedDate = sdf.format(date);
	
		Data = Data + deviceID.substring((deviceID.length()-7)) +","+ formattedDate +","+ loc.getLatitude()+","+ loc.getLongitude() +","+locAge+",";
		Data = Data + 0 +","+ 1 +","+ loc.getSpeed() +","+ (loc.getSpeed()*0.621) +","+loc.getBearing()+",";
		Data = Data + 0 +","+ 0 +","+ loc.getAltitude() +","+ 0 +","+0+","+0+","+0+","+ deviceID +","+0+",";
		Data = Data + 0 +","+ 0;
		
		Log.i("tag","calling send_gps_data " + deviceID.substring(0, 10));
		Log.i(MAINLOG,Data);
		return Data;
	}

	public void send_gps_data(String Data) {
		String msg = Data;
	    int port = 9494;
	    try {
	        DatagramSocket s = new DatagramSocket();
	        InetAddress local  = InetAddress.getByName("162.243.97.40");
	        int msg_lenght = msg.length();
	        byte []message = msg.getBytes();
	        DatagramPacket p = new DatagramPacket(message,msg_lenght,local,port);
	        Log.i(MAINLOG, "Connected to udp server.");
	        s.send(p);
	    } catch (SocketException e) {
	    	Log.e(MAINLOG,e.toString());
	    } catch (UnknownHostException e) {
	    	Log.e(MAINLOG,e.toString());
	    } catch (IOException e) {
	    	Log.e(MAINLOG,e.toString());
	    }catch (	Exception e) {
	    	Log.e(MAINLOG,e.toString());
	    }
	}
}
