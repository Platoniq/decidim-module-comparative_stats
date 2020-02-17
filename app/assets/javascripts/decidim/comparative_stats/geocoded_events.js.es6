// = require leaflet
// = require leaflet.markercluster
// = require leaflet-svg-icon
// = require jquery-tmpl
// = require_self

$(function() {

  var map_object = document.getElementById('geocoded_events');
  var map = L.map(map_object, {
    center: [41,2],
    zoom: 4
  });
  let markerClustersMeetings = L.markerClusterGroup();
  // let markerClustersMeetings = L.markerClusterGroup();

  L.DivIcon.SVGIcon.DecidimIcon = L.DivIcon.SVGIcon.extend({
    options: {
      fillColor: "#ef604d",
      opacity: 0
    },
    _createPathDescription: function() {
      return "M14 1.17a11.685 11.685 0 0 0-11.685 11.685c0 11.25 10.23 20.61 10.665 21a1.5 1.5 0 0 0 2.025 0c0.435-.435 10.665-9.81 10.665-21A11.685 11.685 0 0 0 14 1.17Zm0 17.415A5.085 5.085 0 1 1 19.085 13.5 5.085 5.085 0 0 1 14 18.585Z";
    },
    _createCircle: function() {
      return ""
    }
  });

  L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
  }).addTo(map);

  var events = $('#geocoded_events').data('geocoded-events');
  var meetings = events.meetings;
  var proposals = events.proposals;

  const popupMeetingsTemplateId = "marker-popup-meeting";
  $.template(popupMeetingsTemplateId, $(`#${popupMeetingsTemplateId}`).html());

  for(let key in meetings) {
    var coordinates = [meetings[key].latitude, meetings[key].longitude];
    let marker = L.marker(coordinates, {
      icon: new L.DivIcon.SVGIcon.DecidimIcon()
    });

    let node = document.createElement("div");

    $.tmpl(popupMeetingsTemplateId, meetings[key]).appendTo(node);
    marker.bindPopup(node, {
      maxWidth: 640,
      minWidth: 500,
      keepInView: true,
      className: "map-info"
    }).openPopup();
    markerClustersMeetings.addLayer(marker);
  }

  // map.addLayer(markerClustersMeetings);

  const popupProposalsTemplateId = "marker-popup-proposal";
  $.template(popupProposalsTemplateId, $(`#${popupProposalsTemplateId}`).html());

  for(let key in proposals) {
    var coordinates = [proposals[key].latitude, proposals[key].longitude];
    let marker = L.marker(coordinates, {
      icon: new L.DivIcon.SVGIcon.DecidimIcon()
    });

    let node = document.createElement("div");

    $.tmpl(popupProposalsTemplateId, proposals[key]).appendTo(node);
    marker.bindPopup(node, {
      maxwidth: 640,
      minwidth: 500,
      keepInView: true,
      className: "map-info"
    }).openPopup();
    markerClustersMeetings.addLayer(marker);
  }

  map.addLayer(markerClustersMeetings);

});