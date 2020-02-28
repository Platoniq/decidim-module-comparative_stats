// = require leaflet
// = require leaflet-svg-icon
// = require leaflet.markercluster
// = require jquery-tmpl
// = require_self

$(() => {

  var map_object = document.getElementById('geocoded_events');
  var map = L.map(map_object, {
    center: [41,2],
    zoom: 4
  });

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

  var endpoints = $('#geocoded_events').data('geocoded-events');
  const popupProposalsTemplateId = "marker-popup-proposal";
  $.template(popupProposalsTemplateId, $(`#${popupProposalsTemplateId}`).html());
  const popupMeetingsTemplateId = "marker-popup-meeting";
  $.template(popupMeetingsTemplateId, $(`#${popupMeetingsTemplateId}`).html());

  const randomColor = () => '#'+Math.floor(Math.random()*16777215).toString(16);
  const getMarker = (id, point, color) => {
    let coordinates = [point.latitude, point.longitude];
    let marker = L.marker(coordinates, {
      icon: new L.DivIcon.SVGIcon.DecidimIcon({fillColor: color})
    });

    let node = document.createElement("div");

    $.tmpl(id, point).appendTo(node);
    marker.bindPopup(node, {
      maxWidth: 640,
      minWidth: 500,
      keepInView: true,
      className: "map-info"
    }).openPopup();

    return marker;
  };

  let layers = {};

  for (let endpoint in endpoints) {

    let markerClusters = L.markerClusterGroup();
    let color = randomColor();

    let meetings = endpoints[endpoint].meetings;
    let proposals = endpoints[endpoint].proposals;

    for(let key in meetings) {
      markerClusters.addLayer(getMarker(popupMeetingsTemplateId, meetings[key], color));
    }

    for(let key in proposals) {
      markerClusters.addLayer(getMarker(popupProposalsTemplateId, proposals[key], color));
    }
    markerClusters.addTo(map);
    layers[endpoints[endpoint].name] = markerClusters;
  }

  L.control.layers(null, layers).addTo(map);

  $("[data-tabs]").on('change.zf.tabs', function() {
    map.invalidateSize(true);
  });
});