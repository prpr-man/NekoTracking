# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  center = new google.maps.LatLng(36.10780000000, 140.10869000000)
  options = 
    zoom: 16
    center: center
    mapTypeId: google.maps.MapTypeId.ROADMAP

  map = new google.maps.Map(document.getElementById('map'), options)
  latitudes = gon.lat
  longitudes = gon.lng
  
  for i in [0..latitudes.length-1] by 1
    new google.maps.Marker(
      position: new google.maps.LatLng(latitudes[i].latitude, longitudes[i].longitude)
      map: map
    )

  dispatcher = new WebSocketRails('49.212.151.224:3000/websocket/', true)
  broadcast_channel = dispatcher.subscribe('broadcast_channel')
  broadcast_channel.bind 'new_position', (message) =>
    position = JSON.parse(message)
    $('#new_data').text position.count + ": " + position.lat + ", " + position.lng
    new google.maps.Marker(
      position: new google.maps.LatLng(position.lat, position.lng)
      map: map
    )
