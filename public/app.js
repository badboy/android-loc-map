$(function() {
  var latlng = new google.maps.LatLng(50, -50);
  var myOptions = {
    zoom: 3,
    center: latlng,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };
  GOOG_map = new google.maps.Map(document.getElementById('map_canvas'), myOptions);

  window.GOOG_map = GOOG_map;

  if(window.cache_data && window.cache_data.data) {
    $('#map_canvas').removeClass('o');

    var latlngbounds = new google.maps.LatLngBounds();

    $.each(window.cache_data.data, function(i,row) {
      var myLatLng = new google.maps.LatLng(row.latitude, row.longitude);
      latlngbounds.extend(myLatLng);
      var image = 'beachflag.png';
      var marker = new google.maps.Marker({
        position: myLatLng,
        title: row.key + ", " + row.readtime,
        map: GOOG_map
      });

    })
    GOOG_map.fitBounds(latlngbounds);
  } else {
    alert("No cache data. Wrong file? Use cache.cell or cache.wifi");
  }
});
