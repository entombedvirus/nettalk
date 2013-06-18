class MainCtrl
	ANIMATION_DURATION_MILLIS = 1500
	WAYPOINT_DISTANCE_THRESHOLD = 60

	constructor: (@GoogleMaps, @MapService, @TWEEN, AnimationLoopManager) ->
		AnimationLoopManager.reset()
		@map = MapService.getMap()
		@directionService = new GoogleMaps.DirectionsService()
		@centerMarker = @pinMarker @map.getCenter()
		@bindEvents()

	bindEvents: ->
		@MapService.on "rightclick", (e) =>
			e.stop()
			marker = @pinMarker e.latLng

			req =
				origin: marker.getPosition()
				destination: @centerMarker.getPosition()
				travelMode: @GoogleMaps.TravelMode.DRIVING

			@directionService.route req, (res, status) =>
				# Add the final tween to destination
				res.routes[0].overview_path.push req.destination
				@animateMarker marker, res, status
		@MapService.on "center_changed", (e) =>
			console.log "center_changed", @map.getCenter().toString()

	pinMarker: (position, animation) ->
		new @GoogleMaps.Marker
			map: @map
			position: position
	
	animateMarker: (marker, res, status) =>
		return unless status is @GoogleMaps.DirectionsStatus.OK

		renderer = new @GoogleMaps.DirectionsRenderer
			directions: res
			map: @map
			suppressMarkers: true
			preserveViewport: true

		pos =
			lat: marker.getPosition().lat()
			lng: marker.getPosition().lng()
		tween = new @TWEEN.Tween pos

		curTween = tween
		prevWayPoint = marker.getPosition()

		path = res.routes[0].overview_path
		for wayPoint in path
			distanceToWayPoint = @GoogleMaps.geometry.spherical.computeDistanceBetween(
				prevWayPoint,
				wayPoint
			)
			continue if wayPoint != path[path.length - 1] && distanceToWayPoint < WAYPOINT_DISTANCE_THRESHOLD
#			@pinMarker wayPoint
			duration = Math.min(
				1500,
				(Math.max(0, distanceToWayPoint) / 1500) * ANIMATION_DURATION_MILLIS
			)
			#console.log("distance to next wayPoint", distanceToWayPoint, duration)
			curTween.onUpdate =>
				#console.log("onUpdate chain", pos, @)
				marker.setPosition new @GoogleMaps.LatLng(pos.lat, pos.lng)

			tweenStep = new @TWEEN.Tween(pos).to(
				lat: wayPoint.lat()
				lng: wayPoint.lng()
			,
				duration
			)

			curTween.chain tweenStep
			curTween = tweenStep
			prevWayPoint = wayPoint

		tween.start()

MainCtrl.$inject = [
	'GoogleMaps', 'MapService', 'TWEEN', 'AnimationLoopManager'
]
angular.module('NetTalk.Controllers')
	.controller 'MainCtrl', MainCtrl
