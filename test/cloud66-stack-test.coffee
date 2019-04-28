Helper = require('hubot-test-helper')
Promise = require('bluebird')
chai = require 'chai'
co = require 'co'
nock = require 'nock'

expect = chai.expect

helper = new Helper('../src/cloud66.coffee')

{ stacks_response } = require './mocks/stacks_response.coffee'

describe 'cloud66', ->
  beforeEach ->
    @room = helper.createRoom()

  afterEach ->
    @room.destroy()

  context 'stack info', ->
    beforeEach ->
      nock('https://app.cloud66.com')
        .get('/api/3/stacks.json')
        .reply(200, stacks_response)

      co(() =>
        yield @room.user.say('alice', '@hubot stack list')
        yield new Promise.delay(500)
      )

    it 'responds to stack', ->
      expect(@room.messages).to.eql [
        ['alice', '@hubot stack list']
        ['hubot', {
          'environment': 'development',
          'is_busy': false,
          'name': 'frontend_app',
          'uuid': 'abc-123',
        }]
        ['hubot', {
          'environment': 'development',
          'is_busy': false,
          'name': 'backend_app',
          'uuid': 'abc-345',
        }]
      ]