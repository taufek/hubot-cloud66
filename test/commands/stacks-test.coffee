Helper = require('hubot-test-helper')
Promise = require('bluebird')
chai = require 'chai'
co = require 'co'
nock = require 'nock'

expect = chai.expect

helper = new Helper('../../src/cloud66.coffee')

{ live_stacks_response } = require '../mocks/stacks_response.coffee'

describe 'stacks command', ->
  beforeEach ->
    @room = helper.createRoom()

  afterEach ->
    @room.destroy()

  context 'stacks', ->
    beforeEach ->
      nock('https://app.cloud66.com')
        .get('/api/3/stacks.json')
        .reply(200, live_stacks_response)

      co(() =>
        yield @room.user.say('alice', '@hubot cloud66 stacks')
        yield new Promise.delay(500)
      )

    it 'responds to stack', ->
      expect(@room.messages).to.eql [
        ['alice', '@hubot cloud66 stacks']
        ['hubot', "development frontend_app: Live :rocket:"]
        ['hubot', "development backend_app: Live :rocket:"]
        ['hubot', "development user app: Live :rocket:"]
      ]

  context 'stack info with extra space in between', ->
    beforeEach ->
      nock('https://app.cloud66.com')
        .get('/api/3/stacks.json')
        .reply(200, live_stacks_response)

      co(() =>
        yield @room.user.say('alice', '@hubot  cloud66  stacks')
        yield new Promise.delay(500)
      )

    it 'responds to stack', ->
      expect(@room.messages).to.eql [
        ['alice', '@hubot  cloud66  stacks']
        ['hubot', "development frontend_app: Live :rocket:"]
        ['hubot', "development backend_app: Live :rocket:"]
        ['hubot', "development user app: Live :rocket:"]
      ]
