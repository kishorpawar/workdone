package in.aspade.omnistream;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.MediaController;
import android.widget.VideoView;

public class StreamPlayer extends Activity {
	
	private VideoView vPlayer;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_stream_player);
		
		vPlayer = (VideoView) findViewById(R.id.videoPlayer);
		MediaController playerControl = new MediaController(this);
		playerControl.setAnchorView(vPlayer);
		vPlayer.setMediaController(playerControl);

		Intent videoHandler = this.getIntent();
		
		String urlString = "http://"+Constants.SERVER + ":" + Constants.PORT+
					videoHandler.getStringExtra(Constants.MEDIA_LOCATION);
		
		Log.i("VOD",urlString);
		Uri vUri = Uri.parse(urlString);
		vPlayer.setVideoURI(vUri);
		vPlayer.start();
	}
	
	@Override
	public void onSaveInstanceState(Bundle savedInstanceState) {
		Log.i("VOD", "Before SAVING state.");
		if (vPlayer != null & vPlayer.isPlaying())
		{
			Log.i("VOD", "SAVING state. "+ vPlayer.getCurrentPosition());
			savedInstanceState.putInt("position", vPlayer.getCurrentPosition());
		}
	    // Always call the superclass so it can save the view hierarchy state
	    super.onSaveInstanceState(savedInstanceState);
	}
	
	@Override
	public void onRestoreInstanceState(Bundle savedInstanceState) {
	    // Always call the superclass so it can restore the view hierarchy
	    super.onRestoreInstanceState(savedInstanceState);
	   
	    // Restore state members from saved instance
	    int position = savedInstanceState.getInt("position");
		Log.i("VOD", "Starting at position "+ position);
	    vPlayer.seekTo(position);
	}
	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.stream_player, menu);
		return true;
	}

	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		// Handle action bar item clicks here. The action bar will
		// automatically handle clicks on the Home/Up button, so long
		// as you specify a parent activity in AndroidManifest.xml.
		int id = item.getItemId();
		if (id == R.id.action_settings) {
			return true;
		}
		return super.onOptionsItemSelected(item);
	}
}
