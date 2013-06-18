'use strict'
class Car
	constructor: (@position) ->

	getPosition: -> @position
	setPosition: (@position) ->

getRandomPointWithinBounds = (bounds) ->
	bounds.getNorthWest()

angular.module('NetTalk.Services')
	.factory 'CarFactory', (MapService) ->
		map = MapService.getMap()
		bounds = map.getBounds()

		{
			generate: ->
				startPoint = getRandomPointWithinBounds(bounds) if bounds?
				startPoint ?= map.getCenter()
				new Car(startPoint)
		}
