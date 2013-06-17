'use strict'

describe 'Service: Tower', () ->

	# load the service's module
	beforeEach module 'NetTalkApp'

	# instantiate service
	Tower = {}
	beforeEach inject (_Tower_) ->
		Tower = _Tower_

	it 'should do something', () ->
		expect(!!Tower).toBe true;
