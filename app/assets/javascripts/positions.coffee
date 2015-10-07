# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

setMapAPI = ->
  center = new google.maps.LatLng(38.258595, 137.6850225)
  options = 
    zoom: 5
    center: center
    mapTypeId: google.maps.MapTypeId.ROADMAP

  map = new google.maps.Map(document.getElementById('map'), options)
  latitudes = gon.lat
  longitudes = gon.lng
  positions = []
  marker = null
  
  for i in [0..latitudes.length-1] by 1
    positions.push(new google.maps.LatLng(latitudes[i], longitudes[i]))
  
  if latitudes.length > 0  
    marker = new google.maps.Marker(
      position: new google.maps.LatLng(latitudes[latitudes.length-1], longitudes[longitudes.length-1])
      map: map
      icon: "/assets/pin.png"
    )

  lines = new google.maps.Polyline(
      path: positions
      strokeColor: "#FF0000"
      strokeOpacity: .7
      strokeWeight: 7
    )
  lines.setMap(map);

  #dispatcher = new WebSocketRails('49.212.151.224:3000/websocket/', true)
  dispatcher = new WebSocketRails('localhost:3000/websocket/', true)
  if gon.id
    broadcast_channel = dispatcher.subscribe(''+gon.id)
  else
    broadcast_channel = dispatcher.subscribe("broadcast_channel")

  broadcast_channel.bind 'new_position', (message) =>
    position = JSON.parse(message)
    #$('#new_data').text position.count + ": " + position.lat + ", " + position.lng

    if marker is null
      marker = new google.maps.Marker(
        position: new google.maps.LatLng(position.lat, position.lng)
        map: map
      )
    else
      marker.setPosition(new google.maps.LatLng(position.lat, position.lng))

    positions.push(new google.maps.LatLng(position.lat, position.lng))
    lines = new google.maps.Polyline(
      path: positions
      strokeColor: "#FF0000"
      strokeOpacity: .7
      strokeWeight: 7
    )
    lines.setMap(map);

$(document).ready(setMapAPI)
$(document).on('page:load', setMapAPI)
