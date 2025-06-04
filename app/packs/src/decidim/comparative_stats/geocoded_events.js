import "leaflet"
import "leaflet.markercluster"
import "@decidim/leaflet-svgicon"

document.addEventListener("DOMContentLoaded", function () {
  const map_object = document.getElementById('geocoded_events');
  if (!map_object) {
    return;
  } else {
    map_object._leaflet_id = null;
  }

  const map = L.map(map_object, {
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

  const endpointsElement = document.getElementById('geocoded_events');
  const endpoints = endpointsElement ? JSON.parse(endpointsElement.getAttribute('data-geocoded-events')) : null;

  const popupMeetingsTemplate = (point) => `
    <div class="map-info__content">
      <h3>${point.title}</h3>
      <div id="bodyContent">
        <div class="map__date-adress">
          <div class="card__datetime">
            <div class="card__datetime__date">
              ${point.startTimeDay} <span class="card__datetime__month">${point.startTimeMonth} ${point.startTimeYear}</span>
            </div>
          </div>
          <div class="address card__extra">
            <div class="address__details">
              <strong>${point.location}</strong><br>
              <span>${point.address}</span><br>
            </div>
          </div>
        </div>
        <div class="map-info__button">
          <a href="${point.link}" class="button button--sc">
            View meeting
          </a>
        </div>
      </div>
    </div>
  `;

  const popupProposalsTemplate = (point) => `
    <div class="map-info__content">
      <h3>${point.title}</h3>
      <div id="bodyContent">
        <div class="map__date-adress">
          <div class="address card__extra">
            <div class="address__details">
              <span>${point.address}</span><br>
            </div>
          </div>
        </div>
        <div class="map-info__button">
          <a href="${point.link}" class="button button--sc">
            View proposal
          </a>
        </div>
      </div>
    </div>
  `;

  const randomColor = () => '#'+Math.floor(Math.random()*16777215).toString(16);

  const getMarker = (template, point, color) => {
    let coordinates = [point.latitude, point.longitude];
    let marker = L.marker(coordinates, {
      icon: new L.DivIcon.SVGIcon.DecidimIcon({ fillColor: color })
    });
  
    let node = document.createElement("div");
    node.innerHTML = template(point);
  
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
    // In the future the color should come from the assigned to the endpoint
    let color = randomColor();
    let markerClusters = L.markerClusterGroup({
      iconCreateFunction: function (cluster) {
        const childCount = cluster.getChildCount();
        return new L.DivIcon({ html: '<div style="background-color:' + color +'"><span>' + childCount + '</span></div>', className: 'marker-cluster', iconSize: new L.Point(40, 40) });
      }
    });

    let meetings = endpoints[endpoint].meetings;
    let proposals = endpoints[endpoint].proposals;

    for (let key in meetings) {
      markerClusters.addLayer(getMarker(popupMeetingsTemplate, meetings[key], color));
    }
    
    for (let key in proposals) {
      markerClusters.addLayer(getMarker(popupProposalsTemplate, proposals[key], color));
    }
    markerClusters.addTo(map);
    let key = '<span class="endpoint-legend"><span class="square" style="background-color:' + color +'"></span>' + endpoints[endpoint].name + '</span>';
    layers[key] = markerClusters;
  }

  L.control.layers(null, layers).addTo(map);

  document.querySelectorAll("[data-tabs]").forEach(element => {
    element.addEventListener("change", function () {
      map.invalidateSize(true);
    });
  });
});
