'use strict'

describe 'Service: CarFactory', () ->

  # load the service's module
  beforeEach module 'nettalkApp'

  # instantiate service
  CarFactory = {}
  beforeEach inject (_CarFactory_) ->
    CarFactory = _CarFactory_

  it 'should do something', () ->
    expect(!!CarFactory).toBe true;
