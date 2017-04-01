//Created on April 1, 2013 
//This file contains function that are repeated more than once in gps-maps section

var first_lat=0;
var first_lon=0;
var first = true;
var new_pattern = "";
var ONE_KM_IN_MILE = 0.621371

// Function to get the distance between two points
function getDistance(first_lat, first_lon, lat, lon) {
	var radlat1 = Math.PI * first_lat/180;
	var radlat2 = Math.PI * lat/180;
	var radlon1 = Math.PI * first_lon/180;
	var radlon2 = Math.PI * lon/180;
	var theta = first_lon-lon;
	var radtheta = Math.PI * theta/180;
	var dist = Math.sin(radlat1) * Math.sin(radlat2) + Math.cos(radlat1)
			   * Math.cos(radlat2) * Math.cos(radtheta);
	dist = Math.acos(dist);
	dist = dist * 180/Math.PI;
	dist = dist * 60 * 1.1515;
	dist = dist * 1.609344 ;
	return dist;
} 

// build marker for the given co-ordinate

function buildMarker(map,lat,lon,srno,name,speed,
		              date,time,ignition,odometer,
					  stop_time,idle_time,unit,odometer_mph,offset) {
	
	var latlng = new google.maps.LatLng(lat, lon);

//	date = format(dateformat,new Date(date))
//	console.log((new Date() - new Date(date+" "+time)))
//	new_time = clock_time(timeformat,time)
	ignition = ignition.toString();
    if(unit == 2)
	{
    	unit_text = 'km';
    	odometer = eval(odometer) + eval(offset)
	}
    else
	{
    	unit_text = 'miles';
    	offset = eval(offset) * ONE_KM_IN_MILE
    	odometer = eval(odometer_mph) + offset
	}

    if (first==true){
    	first_lat = lat;
    	first_lon = lon;
    	first = false;
    }
    
    if(ignition == "True" || ignition == "true" || ignition == 1)
    	var onf = "ON"
    else if(ignition == "False" || ignition == "false" || ignition == 0) 
    	var onf = "OFF"

	content = {"speed":speed,"date":date,"idl":'IDL/PRK',
    			"onf":onf,"time":time,"moving":'MOVING',"odometer":Math.round(odometer),
    			"name":name,"srno":srno,"stop_time":stop_time,
    			"idle_time":idle_time, "unit":unit_text }
    
    var marker = map.addMarker({
    	lat : lat,
    	lng : lon,
    	title: name,
    	details : content,
//    	animation: google.maps.Animation.DROP,
//    	flat : true,
    })
    
    /* map.setContextMenu({
		control: 'marker',
		options: [{
		    title: 'Live Track',
		    name: 'live_track',
		    action: function(){
		    	console.log(map.markers[0]);
		    	srno = marker.details["srno"];
		    	name = marker.details["name"];
		    	url = "/gps/track/" + srno + "/vehicle/";
				newWindow(url, srno, name);
		    } 
	    }]
	}) */
	
    var Icon = "";
    //User's Dateformat to JS requierd DateFormat if user's dateformat is from these two below.
    if(dateformat == '%d/%m/%y')
    {
    	temp_date = date.split("/");
    	date = "20"+temp_date[2]+"/"+temp_date[1]+"/"+temp_date[0];
    }
    if(dateformat == '%y/%m/%d')
    {
    	temp_date = date.split("/");
    	date = "20"+temp_date[0]+"/"+temp_date[1]+"/"+temp_date[2];
    }
    /*
     * Converting The user's date format to Javascript's Dateformat.
    	console.log(dateformat);
    	console.log(date);
        first_part = date.substr(0,dateformat.indexOf("%y"));
        middle_part = date.substr(dateformat.indexOf("%y"),2);
        last_part = date.substring(dateformat.indexOf("%y")+2);
        date = first_part +new Date().getFullYear().toString().slice(0,2)+middle_part+last_part;
        console.log(date);
        console.log(new Date(date+" "+time) + "JS Date");
     */
    if((new Date() - new Date(date+" "+time))/(60000) >= 6)
	{
    	Icon = "/static/images/Ig_NO_DATA.png"
	}
    else if (ignition == "False" || ignition == "false" || ignition == 0){
        Icon = "/static/images/Ig_OFF.png";
    } else if((ignition == "True" || ignition == "true" || ignition == 1) && speed==0){
        Icon = "/static/images/Ig_ON_IDL.png";
    }
    else if((ignition == "True" || ignition == "true" || ignition == 1) && speed > 0){
        Icon = "/static/images/Ig_ON_MOV.png";
    }
    else{
    	Icon = "/static/images/Ig_NO_DATA.png";
    }
    
    marker.setIcon(Icon);
    bounds.extend(latlng);
	distance = getDistance(first_lat, first_lon, lat, lon) // function def is
															// present in
															// 'gps_library.js'
    // map.fitBounds(bounds);
    
    // a routine adjust the pan and zoom level for the map in-case of closely
    // placed markers.
    if (first==false){
		if(distance <= 0.2) { 
	    	//map.fitBounds(bounds);
		    var listener = google.maps.event.addListener(map, "idle", function() { 
		                    if (map.getZoom() > 15) map.setZoom(15); 
		                        google.maps.event.removeListener(listener); 
		                    });
	    } else {
			//map.fitBounds(bounds);
	    }
	} else {
		//map.fitBounds(bounds);
	}
	return marker
}

function scriptCompatibleDate(year,month,day,hours,mins,secs)
{	
	month = month - 1
	
	return [year,month,day,hours,mins,secs]
}

//FUNCTION OPENS NEW WINDOW FOR INDIVIDUAL VEHICLES
function newWindow(url, srno,name) {
    var width  = 600;
    var height = 640;
    var left   = (screen.width  - width)/2;
    var top    = (screen.height - height)/2;
    var params = 'width='+width+', height='+height;
    params += ', top='+top+', left='+left;
    params += ', directories=no';
    params += ', location=no';
    params += ', menubar=no';
    if(!document.all & document.getElementById){
       params += ', resizable=0';
    }else {
        params += ', resizable=no';
    }
    params += ', scrollbars=no';
    params += ', status=no';
    params += ', toolbar=no';

    var newwin=window.open(url,srno,params);
  }


function get_snapshot() {
	marker_srno = this.details["srno"]
	
//	$("#vehi-list option:first").text((this.details["name"]));
	$("#vehi-list").val(this.details["srno"]);
	
	var lat = this.position.lat()
	var lng = this.position.lng()	
	var latlng = new google.maps.LatLng(lat,lng);
	var geocoder = new google.maps.Geocoder();
	var address ;
	var marker = this
	geocoder.geocode( { 'latLng': latlng}, function(results, status) 
	{
		if (status == google.maps.GeocoderStatus.OK)
		{
			address = results[1].formatted_address
		}
		ignition = marker.details["onf"]
		speed = marker.details["speed"]
		$("#onf").text(marker.details["onf"]);
		$("#dte").text(marker.details["date"]);
		$("#tme").text(marker.details["time"]);
		$("#odo").text(marker.details["odometer"]+' '+marker.details["unit"]);
		$("#addr span").text(address);
		
		if(ignition == "OFF")
		{
			$("#mov-stat span").text("PARKED");
			$("#mov-val span").text(marker.details["stop_time"]);
		}
		else if(ignition=="ON" && parseInt(speed) == 0)
		{	
			$("#mov-stat span").text("IDLE");
			$("#mov-val span").text(marker.details["idle_time"]);
		}
		else if(ignition=="ON" && parseInt(speed) > 0)
		{	
			$("#mov-stat span").text("MOVING");
			$("#mov-val span").text(speed+' '+marker.details["unit"][0]+"ph");
		}
	});
 }


function get_snapshot_list(e) {
	marker_srno = e.details["srno"]
	$("#vehi-list").val(e.details["srno"]);
	var lat = e.position.lat()
	var lng = e.position.lng()
	
	var latlng = new google.maps.LatLng(lat,lng);
	var geocoder = new google.maps.Geocoder();
	var address ;
	var marker = e;
	geocoder.geocode( { 'latLng': latlng}, function(results, status) 
	{
		if (status == google.maps.GeocoderStatus.OK)
		{
			address = results[1].formatted_address
		}
//		console.log(marker.details["time"])
		ignition = marker.details["onf"]
		speed = marker.details["speed"]
		$("#onf").text(marker.details["onf"]);
		$("#dte").text(marker.details["date"]);
		$("#tme").text(marker.details["time"]);
		$("#odo").text(marker.details["odometer"]+' '+marker.details["unit"]);
		$("#addr span").text(address);
		
		if(ignition == "OFF")
		{
			$("#mov-stat span").text("PARKED");
			$("#mov-val span").text(marker.details["stop_time"]);
		}
		else if(ignition=="ON" && parseInt(speed) == 0)
		{	
			$("#mov-stat span").text("IDLE");
			$("#mov-val span").text(marker.details["idle_time"]);
		}
		else if(ignition=="ON" && parseInt(speed) > 0)
		{	
			$("#mov-stat span").text("MOVING");
			$("#mov-val span").text(speed+' '+marker.details["unit"][0]+"ph");
		}
	});
}


function min_to_time(min)
{	
	min = min * 60
	if (min > 0)
	{
	    hrs = min / 3600;
	    hr_rem = min % 3600;
	    min = hr_rem / 60;
	    //sec = hr_rem % 60;
	}
	else
	{
	    hrs = 0
	    min = 0
	    //sec = 0
	}
	
	if (hrs < 10)
		hrs = "0"+Math.floor(hrs)
	else
		hrs = Math.floor(hrs)
	if ( min < 10)
		min = "0"+Math.floor(min)
	else
		min = Math.floor(min)

	return ( hrs+" hrs:"+min+" mins")
}

/*
 * carpath  - an array of lat longs and other information
 * update_time is in milliseconds
 */

function animateCircle(carpath, update_time) {
	
    var count = 0;
    window.setInterval(function()
    {
    	count = (count + 1)  % 2000;

    	var icons = carpath.get('icons');
    	icons[0].offset = (count / 2) + '%';
    	carpath.set('icons', icons);
    }, update_time); 
}


function getMap(zoom,map_center)
{
	if(map_center == undefined)
	{
		map_center = new google.maps.LatLng(23.30, 80.00)
	}
	
	if(zoom == undefined )
		zoom = 5
		
	var map = new GMaps({
        el: '#map-canvas',
//        lat: 23.30,
//        lng: 80.00,
        center: map_center,
        zoom:zoom,
        zoomControl : true,
  	});
  	
	return map;
}

function get_Date_Time(date)
{
	console.log(date)
	var dt = scriptCompatibleDate(eval(date[0]),eval(date[1]),eval(date[2]),eval(date[3]),
								  eval(date[4]),eval(date[5]),eval(date[6])	)
	var date = new Date(dt[0],dt[1],dt[2],dt[3],dt[4],dt[5]);
	var time = date.toLocaleTimeString()
	date = date
	return [date,time]
}



// this function is created so that django's or python's date and time formats
// can be used as it is here in javascript.

function format(pattern, date) //date = dateobject not string pattern=string
{
//	console.log("pattern " + pattern)
//	console.log("date given "+ date)
	var date_format = pattern.split('%')
	new_pattern = pattern
	for(j=0;j<date_format.length;j++)
	{
		switch(date_format[j])
		{
			case "d/":
			case "d":
			case "d, ":
				new_pattern	= new_pattern.replace("%"+date_format[j],"dd"+ date_format[j].substr(1,1))
				break;
			case "m/":
			case "m":
				new_pattern	= new_pattern.replace("%"+date_format[j],"mm"+ date_format[j].substr(1,1))
				break;
			case "y/":
			case "y":
				new_pattern	= new_pattern.replace("%"+date_format[j],"y"+ date_format[j].substr(1,1))
				break;
			case "Y/":
			case "Y":
				new_pattern	= new_pattern.replace("%"+date_format[j],"yy"+ date_format[j].substr(1,1))
				break;
			case "B/":
			case "B ":
				new_pattern	= new_pattern.replace("%"+date_format[j],"MM"+ date_format[j].substr(1,1))
				break;
			case "b/":
			case "b ":
				new_pattern	= new_pattern.replace("%"+date_format[j],"M"+ date_format[j].substr(1,1))
				break;
//			case "I:":
//				new_pattern	= new_pattern.replace("%"+date_format[i],"@")
//				console.log("II"+new_pattern)
//				break;
//			case "H:":
//				new_pattern	= new_pattern.replace("%"+date_format[i],"@:")
//				break;
//			case "M":
//				new_pattern	= new_pattern.replace("%"+date_format[i],"@"+ date_format[i].substr(1,1))
//				break;
		}
	}
	formatted_date = $.datepicker.formatDate(new_pattern,date)
//	console.log("formatted date "+ formatted_date)
	return formatted_date	
}

function clock_time(pattern,time_to_format)
{
//	console.log("datetime ."+new Date(time_to_format))
	var d = new Date(time_to_format)
	var h=addMeridian(addZero(d.getHours()),pattern);
	var m=addZero(d.getMinutes());
	var s=addZero(d.getSeconds());
	if(pattern.indexOf("%I")!=-1)
	{
		return (h[0] + ":" + m + ":" + s +" "+h[1]);
	}
	else if (pattern.indexOf("%H")!=-1)
	{	
		return (h[0] + ":" + m + ":" + s);
	}
}

function addZero(i)
{
	if (i<10) 
    {
		i="0" + i;
	}
	return i;
}

function addMeridian(i,pattern)
{
	var flag = "am"
	if (i>=12 && pattern.indexOf("%I")!=-1) 
    {
		i = i-12;
		flag = "pm"
		if (i == 0)
		{
			i=12;
		}
	}
	return [i,flag];
}
