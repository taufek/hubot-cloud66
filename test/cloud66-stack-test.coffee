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

  context 'stack with existing stack_name', ->
    beforeEach ->
      nock('https://app.cloud66.com')
        .get('/api/3/stacks.json')
        .reply(200, stacks_response)

      co(() =>
        yield @room.user.say('alice', '@hubot cloud66 stack development backend_app')
        yield new Promise.delay(500)
      )

    it 'responds to stack', ->
      expect(@room.messages).to.eql [
        ['alice', '@hubot cloud66 stack development backend_app']
        ['hubot', 'development backend_app: Deploying :hammer_and_wrench:']
      ]

  context 'stack with existing stack_name containing space', ->
    beforeEach ->
      nock('https://app.cloud66.com')
        .get('/api/3/stacks.json')
        .reply(200, stacks_response)

      co(() =>
        yield @room.user.say('alice', '@hubot cloud66 stack development user app')
        yield new Promise.delay(500)
      )

    it 'responds to stack', ->
      expect(@room.messages).to.eql [
        ['alice', '@hubot cloud66 stack development user app']
        ['hubot', 'development user app: Deploying :hammer_and_wrench:']
      ]

  context 'stack with non_existing stack_name', ->
    beforeEach ->
      nock('https://app.cloud66.com')
        .get('/api/3/stacks.json')
        .reply(200, stacks_response)

      co(() =>
        yield @room.user.say('alice', '@hubot cloud66 stack development non_existing_app')
        yield new Promise.delay(500)
      )

    it 'responds to stack', ->
      expect(@room.messages).to.eql [
        ['alice', '@hubot cloud66 stack development non_existing_app']
        ['hubot', 'Invalid stack_name']
      ]

