'use strict'

class AnimationLoopManager
	constructor: (@$window, @TWEEN) ->
		@animate()

	animate: =>
		return if @paused
		@$window.requestAnimationFrame(@animate);
		@TWEEN.update()

	reset: ->
		@paused = false
		@startTime = new Date

	pause: ->
		@paused = true

	resume: ->
		@paused = false
		@animate()

angular.module('NetTalk.Services')
  .factory 'AnimationLoopManager', ($window, TWEEN) -> new AnimationLoopManager($window, TWEEN)