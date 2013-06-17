class MainCtrl
	ANIMATION_DURATION_MILLIS = 1500

	constructor: ($scope, $timeout, @google, Geolocation) ->
		# Enable the visual refresh
		@google.maps.visualRefresh = true
		@map = @initializeMap()
		@directionService = new @google.maps.DirectionsService()
		@centerMarker = @pinMarker @map.getCenter()
		@bindEvents()

	initializeMap: ->
		new @google.maps.Map document.getElementById("map-canvas"),
			center: new @google.maps.LatLng 37.7789, -122.3917
			zoom: 15
			mapTypeId: @google.maps.MapTypeId.ROADMAP

	bindEvents: ->
		@google.maps.event.addListener @map, "rightclick", (e) =>
			e.stop()
			marker = @dropBadGuyAt e.latLng
			@getDirectionsFromTo marker, @centerMarker

	pinMarker: (position, animation) ->
		markerOpts =
			map: @map
			position: position
			animation: animation ? @google.maps.Animation.DROP
		new @google.maps.Marker markerOpts
	
	dropBadGuyAt: (latLng) ->
		@pinMarker latLng
	
	getDirectionsFromTo: (fromMarker, toMarker) ->
		req =
			origin: fromMarker.getPosition()
			destination: toMarker.getPosition()
			travelMode: @google.maps.TravelMode.DRIVING

		@directionService.route req, (res, status) =>
			if status is @google.maps.DirectionsStatus.OK
				renderer = new @google.maps.DirectionsRenderer
					directions: res
					map: @map
					suppressMarkers: true
					preserveViewport: true

				pos =
					lat: req.origin.lat()
					lng: req.origin.lng()
				tween = new TWEEN.Tween pos

				curTween = tween
				prevWayPoint = fromMarker.getPosition()

				for wayPoint in res.routes[0].overview_path
					#@pinMarker wayPoint
					distanceToWayPoint = @google.maps.geometry.spherical.computeDistanceBetween(
						prevWayPoint,
						wayPoint
					)
					duration = Math.min(
						1500,
						(Math.max(0, distanceToWayPoint) / 1500) * ANIMATION_DURATION_MILLIS
					)
					console.log("distance to next wayPoint", distanceToWayPoint, duration)
					curTween.onUpdate ->
						#console.log("onUpdate chain", pos, @)
						fromMarker.setPosition new maps.LatLng(@lat, @lng)

					tweenStep = new TWEEN.Tween(pos).to
						lat: wayPoint.lat()
						lng: wayPoint.lng()
					,
						duration

					curTween.chain tweenStep
					curTween = tweenStep
					prevWayPoint = wayPoint

				maps = @google.maps
				tween.start()
				animate = ->
					window.requestAnimationFrame animate
					TWEEN.update()
				animate()


angular.module('NetTalk.Controllers', [])
	.controller 'MainCtrl', ['$scope', '$timeout', 'google', 'Geolocation', MainCtrl]
