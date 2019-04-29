Helper = require('hubot-test-helper')
Promise = require('bluebird')
chai = require 'chai'
co = require 'co'
nock = require 'nock'

expect = chai.expect

helper = new Helper('../src/cloud66.coffee')

{ stacks_response } = require './mocks/stacks_response.coffee'
{ deployments_response } = require './mocks/deployments_response.coffee'

describe 'cloud66', ->
  beforeEach ->
    @room = helper.createRoom()

  afterEach ->
    @room.destroy()

  context 'deployment with existing stack_name', ->
    beforeEach ->
      nock('https://app.cloud66.com')
        .get('/api/3/stacks.json')
        .reply(200, stacks_response)

      nock('https://app.cloud66.com')
        .get("/api/3/stacks/abc-345/deployments")
        .reply(200, deployments_response)

      co(() =>
        yield @room.user.say('alice', '@hubot cloud66 deployment development backend_app')
        yield new Promise.delay(500)
      )

    it 'responds to deployment', ->
      expect(@room.messages).to.eql [
        ['alice', '@hubot cloud66 deployment development backend_app']
        ['hubot', 'development backend_app deployment: Deployment completed :rocket:']
      ]

  context 'deployment with existing stack_name containing space', ->
    beforeEach ->
      nock('https://app.cloud66.com')
        .get('/api/3/stacks.json')
        .reply(200, stacks_response)

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
        ['hubot', 'development user app deployment: Deployment completed :rocket:']
      ]

  context 'deployment with non_existing stack_name', ->
    beforeEach ->
      nock('https://app.cloud66.com')
        .get('/api/3/stacks.json')
        .reply(200, stacks_response)

      co(() =>
        yield @room.user.say('alice', '@hubot cloud66 deployment development non_existing_app')
        yield new Promise.delay(500)
      )

    it 'responds to deployment', ->
      expect(@room.messages).to.eql [
        ['alice', '@hubot cloud66 deployment development non_existing_app']
        ['hubot', 'Invalid stack_name']
      ]

