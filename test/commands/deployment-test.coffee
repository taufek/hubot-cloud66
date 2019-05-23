Helper = require('hubot-test-helper')
Promise = require('bluebird')
chai = require 'chai'
co = require 'co'
nock = require 'nock'

expect = chai.expect

helper = new Helper('../../src/cloud66.coffee')

{ live_stacks_response } = require '../mocks/stacks_response.coffee'
{ deployments_response } = require '../mocks/deployments_response.coffee'

describe 'deployment command', ->
  beforeEach ->
    @room = helper.createRoom()

  afterEach ->
    @room.destroy()

  context 'deployment with existing stack_name', ->
    beforeEach ->
      nock('https://app.cloud66.com')
        .get('/api/3/stacks.json')
        .reply(200, live_stacks_response)

      nock('https://app.cloud66.com')
        .get("/api/3/stacks/abc-345/deployments")
        .reply(200, deployments_response)

      co(() =>
        yield @room.user.say('alice', '@hubot cloud66 deployment development backend_app')
        yield new Promise.delay(500)
      )

    it('responds to development', () ->
      expect(@room.messages).to.eql [
        ['alice', '@hubot cloud66 deployment development backend_app']
        ['hubot', 'Here is the latest deployment commit hash for development backend_app']
        ['hubot', "Commit #{deployments_response.response[0].commit_url}"]
      ]
    )

  context 'deployment with extra space in between', ->
    beforeEach ->
      nock('https://app.cloud66.com')
        .get('/api/3/stacks.json')
        .reply(200, live_stacks_response)

      nock('https://app.cloud66.com')
        .get("/api/3/stacks/abc-345/deployments")
        .reply(200, deployments_response)

      co(() =>
        yield @room.user.say('alice', '@hubot  cloud66  deployment  development  backend_app')
        yield new Promise.delay(500)
      )

    it('responds to deployment', () ->
      expect(@room.messages).to.eql [
        ['alice', '@hubot  cloud66  deployment  development  backend_app']
        ['hubot', 'Here is the latest deployment commit hash for development backend_app']
        ['hubot', "Commit #{deployments_response.response[0].commit_url}"]
      ]
    )

  context 'deployment with existing stack_name containing space', ->
    beforeEach ->
      nock('https://app.cloud66.com')
        .get('/api/3/stacks.json')
        .reply(200, live_stacks_response)

      nock('https://app.cloud66.com')
        .get("/api/3/stacks/abc-567/deployments")
        .reply(200, deployments_response)

      co(() =>
        yield @room.user.say('alice', '@hubot cloud66 deployment development user app')
        yield new Promise.delay(500)
      )

    it 'responds to deployment', ->
      expect(@room.messages).to.eql [
        ['alice', '@hubot cloud66 deployment development user app']
        ['hubot', 'Here is the latest deployment commit hash for development user app']
        ['hubot', "Commit #{deployments_response.response[0].commit_url}"]
      ]

  context 'deployment with non-existing stack_name', ->
    beforeEach ->
      nock('https://app.cloud66.com')
        .get('/api/3/stacks.json')
        .reply(200, live_stacks_response)

      co(() =>
        yield @room.user.say('alice', '@hubot cloud66 deployment development non-existing app')
        yield new Promise.delay(500)
      )

    it 'responds to deployment', ->
      expect(@room.messages).to.eql [
        ['alice', '@hubot cloud66 deployment development non-existing app']
        ['hubot', 'Invalid stack_name']
      ]

  context 'deployment with empty deployments', ->
    beforeEach ->
      nock('https://app.cloud66.com')
        .get('/api/3/stacks.json')
        .reply(200, live_stacks_response)

      nock('https://app.cloud66.com')
        .get("/api/3/stacks/abc-345/deployments")
        .reply(200, [])

      co(() =>
        yield @room.user.say('alice', '@hubot cloud66 deployment development backend_app')
        yield new Promise.delay(500)
      )

    it('responds to development', () ->
      expect(@room.messages).to.eql [
        ['alice', '@hubot cloud66 deployment development backend_app']
        ['hubot', 'No deployment']
      ]
    )
