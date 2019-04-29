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

  context 'redeploy with existing stack_name', ->
    beforeEach ->
      @deploy_response = {
        response: {
          ok: true,
          message: 'Stack starting redeployment'
        }
      }

      nock('https://app.cloud66.com')
        .get('/api/3/stacks.json')
        .reply(200, stacks_response)

      nock('https://app.cloud66.com')
        .post("/api/3/stacks/abc-345/deployments")
        .reply(200, @deploy_response)

      co(() =>
        yield @room.user.say('alice', '@hubot cloud66 redeploy development backend_app')
        yield new Promise.delay(500)
      )

    it 'responds to redeploy', ->
      expect(@room.messages).to.eql [
        ['alice', '@hubot cloud66 redeploy development backend_app']
        ['hubot', 'Deploying development backend_app (abc-345)']
        ['hubot', 'Stack starting redeployment']
      ]

  context 'redeploy with existing stack_name containing space', ->
    beforeEach ->
      @deploy_response = {
        response: {
          ok: true,
          message: 'Stack starting redeployment'
        }
      }

      nock('https://app.cloud66.com')
        .get('/api/3/stacks.json')
        .reply(200, stacks_response)

      nock('https://app.cloud66.com')
        .post("/api/3/stacks/abc-567/deployments")
        .reply(200, @deploy_response)

      co(() =>
        yield @room.user.say('alice', '@hubot cloud66 redeploy development user app')
        yield new Promise.delay(500)
      )

    it 'responds to redeploy', ->
      expect(@room.messages).to.eql [
        ['alice', '@hubot cloud66 redeploy development user app']
        ['hubot', 'Deploying development user app (abc-567)']
        ['hubot', 'Stack starting redeployment']
      ]

  context 'redeploy with non_existing stack_name', ->
    beforeEach ->
      nock('https://app.cloud66.com')
        .get('/api/3/stacks.json')
        .reply(200, stacks_response)

      co(() =>
        yield @room.user.say('alice', '@hubot cloud66 redeploy development non_existing_app')
        yield new Promise.delay(500)
      )

    it 'responds to deploy', ->
      expect(@room.messages).to.eql [
        ['alice', '@hubot cloud66 redeploy development non_existing_app']
        ['hubot', 'Invalid stack_name']
      ]

