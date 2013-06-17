'use strict'

describe 'Service: AnimationLoopManager', () ->

  # load the service's module
  beforeEach module 'NetTalkApp'

  # instantiate service
  AnimationLoopManager = {}
  beforeEach inject (_AnimationLoopManager_) ->
    AnimationLoopManager = _AnimationLoopManager_

  it 'should do something', () ->
    expect(!!AnimationLoopManager).toBe true;
