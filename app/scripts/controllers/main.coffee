angular.module('NetTalk.Controllers', [])
	.controller 'MainCtrl', (@google, Geolocation) ->
		# Enable the visual refresh
		@google.maps.visualRefresh = true
		success = (position) =>
			@initializeMap position.coords

		error = =>
			@initializeMap
				latitude: -34.397
				longitude: 150.644

		if Geolocation?.getCurrentPosition
			Geolocation.getCurrentPosition success, error
		else
			error()
	
	initializeMap: (position) ->
		position = new @google.maps.LatLng(position.latitude, position.longitude)
		mapOptions =
			center: position
			zoom: 17
			mapTypeId: @google.maps.MapTypeId.ROADMAP

		map = new @google.maps.Map(document.getElementById("map-canvas"), mapOptions)
		markerOpts =
			map: map
			position: position

		marker = new @google.maps.Marker markerOpts
		circleArea = new @google.maps.Circle
			map: map
			center: position
			radius: 80
			strokeColor: "#0000fb"
			strokeWeight: 1
			fillColor: "#0000fc"
			strokeOpacity: 0.5
