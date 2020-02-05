//= require leaflet
//= require_self

$(function() {

  var map_object = document.getElementById('upcoming_events');
  var map = L.map(map_object, {
    center: [41,2],
    zoom: 4
  });
  
  L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
  }).addTo(map);

});