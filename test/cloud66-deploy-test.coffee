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

  context 'deploy with existing stack_name', ->
    beforeEach ->
      @deploy_response = {
        response: {
          ok: true,
          message: 'Stack queued for redeployment'
        }
      }

      nock('https://app.cloud66.com')
        .get('/api/3/stacks.json')
        .reply(200, stacks_response)

      nock('https://app.cloud66.com')
        .post("/api/3/stacks/abc-345/deployments")
        .reply(200, @deploy_response)

      co(() =>
        yield @room.user.say('alice', '@hubot deploy development backend_app')
        yield new Promise.delay(500)
      )

    it 'responds to deploy', ->
      expect(@room.messages).to.eql [
        ['alice', '@hubot deploy development backend_app']
        ['hubot', 'Stack queued for redeployment']
      ]

  context 'deploy with non_existing stack_name', ->
    beforeEach ->
      nock('https://app.cloud66.com')
        .get('/api/3/stacks.json')
        .reply(200, stacks_response)

      co(() =>
        yield @room.user.say('alice', '@hubot deploy development non_existing_app')
        yield new Promise.delay(500)
      )

    it 'responds to deploy', ->
      expect(@room.messages).to.eql [
        ['alice', '@hubot deploy development non_existing_app']
        ['hubot', 'Invalid stack_name']
      ]

