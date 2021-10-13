Helper = require('hubot-test-helper')
Promise = require('bluebird')
chai = require 'chai'
co = require 'co'
nock = require 'nock'

expect = chai.expect

helper = new Helper('../../src/cloud66.coffee')
process.env.EXPRESS_PORT = 8080

{ live_stacks_response, deploying_stacks_response } = require '../mocks/stacks_response.coffee'

describe 'redeploy command', ->
  beforeEach ->
    @initialInterval = process.env.CLOUD66_INTERVAL_IN_MS
    @initialDelay = process.env.CLOUD66_INTERVAL_IN_MS
    process.env.CLOUD66_INTERVAL_IN_MS = 500
    process.env.CLOUD66_DELAY_IN_MS = 100
    @room = helper.createRoom()

  afterEach ->
    @room.destroy()
    process.env.CLOUD66_INTERVAL_IN_MS = @initialInterval
    process.env.CLOUD66_DELAY_IN_MS = @initialDelay

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
        .reply(200, live_stacks_response)

      nock('https://app.cloud66.com')
        .post("/api/3/stacks/abc-345/deployments")
        .reply(200, @deploy_response)

      nock('https://app.cloud66.com')
        .get("/api/3/stacks/abc-345")
        .reply(200, {
          response: {
            uid: 'abc-345',
            name: 'backend_app',
            environment: 'development',
            status: 6,
            health: 3
          }
        })

      nock('https://app.cloud66.com')
        .get("/api/3/stacks/abc-345")
        .reply(200, {
          response: {
            uid: 'abc-345',
            name: 'backend_app',
            environment: 'development',
            status: 6,
            health: 3
          }
        })

      nock('https://app.cloud66.com')
        .get("/api/3/stacks/abc-345")
        .reply(200, {
          response: {
            uid: 'abc-345',
            name: 'backend_app',
            environment: 'development',
            status: 1,
            health: 3
          }
        })

      co(() =>
        yield @room.user.say('alice', '@hubot cloud66 redeploy development backend_app')
        yield new Promise.delay(1000)
      )

    it('responds to redeploy', () ->
      expect(@room.messages).to.eql [
        ['alice', '@hubot cloud66 redeploy development backend_app']
        ['hubot', 'Stack starting redeployment']
        ['hubot', 'development backend_app: Deploying :hammer_and_wrench:']
        ['hubot', 'development backend_app: Live :rocket:']
      ]
    )

  context 'redeploy with extra space in between', ->
    beforeEach ->
      @deploy_response = {
        response: {
          ok: true,
          message: 'Stack starting redeployment'
        }
      }

      nock('https://app.cloud66.com')
        .get('/api/3/stacks.json')
        .reply(200, live_stacks_response)

      nock('https://app.cloud66.com')
        .post("/api/3/stacks/abc-345/deployments")
        .reply(200, @deploy_response)

      nock('https://app.cloud66.com')
        .get("/api/3/stacks/abc-345")
        .reply(200, {
          response: {
            uid: 'abc-345',
            name: 'backend_app',
            environment: 'development',
            status: 6,
            health: 3
          }
        })

      nock('https://app.cloud66.com')
        .get("/api/3/stacks/abc-345")
        .reply(200, {
          response: {
            uid: 'abc-345',
            name: 'backend_app',
            environment: 'development',
            status: 6,
            health: 3
          }
        })

      nock('https://app.cloud66.com')
        .get("/api/3/stacks/abc-345")
        .reply(200, {
          response: {
            uid: 'abc-345',
            name: 'backend_app',
            environment: 'development',
            status: 1,
            health: 3
          }
        })

      co(() =>
        yield @room.user.say('alice', '@hubot  cloud66  redeploy  development  backend_app')
        yield new Promise.delay(1000)
      )

    it('responds to redeploy', () ->
      expect(@room.messages).to.eql [
        ['alice', '@hubot  cloud66  redeploy  development  backend_app']
        ['hubot', 'Stack starting redeployment']
        ['hubot', 'development backend_app: Deploying :hammer_and_wrench:']
        ['hubot', 'development backend_app: Live :rocket:']
      ]
    )

  context 'redeploy hits max attempts', ->
    beforeEach ->
      @initialAttempts = process.env.CLOUD66_MAX_ATTEMPTS
      process.env.CLOUD66_MAX_ATTEMPTS = 1

      @deploy_response = {
        response: {
          ok: true,
          message: 'Stack starting redeployment'
        }
      }

      nock('https://app.cloud66.com')
        .get('/api/3/stacks.json')
        .reply(200, live_stacks_response)

      nock('https://app.cloud66.com')
        .post("/api/3/stacks/abc-345/deployments")
        .reply(200, @deploy_response)

      nock('https://app.cloud66.com')
        .get("/api/3/stacks/abc-345")
        .reply(200, {
          response: {
            uid: 'abc-345',
            name: 'backend_app',
            environment: 'development',
            status: 6,
            health: 3
          }
        })

      nock('https://app.cloud66.com')
        .get("/api/3/stacks/abc-345")
        .reply(200, {
          response: {
            uid: 'abc-345',
            name: 'backend_app',
            environment: 'development',
            status: 6,
            health: 3
          }
        })

      nock('https://app.cloud66.com')
        .get("/api/3/stacks/abc-345")
        .reply(200, {
          response: {
            uid: 'abc-345',
            name: 'backend_app',
            environment: 'development',
            status: 6,
            health: 3
          }
        })

      co(() =>
        yield @room.user.say('alice', '@hubot cloud66 redeploy development backend_app')
        yield new Promise.delay(1000)
      )

    afterEach ->
      process.env.CLOUD66_MAX_ATTEMPTS = @initialAttempts

    it('responds to redeploy', () ->
      expect(@room.messages).to.eql [
        ['alice', '@hubot cloud66 redeploy development backend_app']
        ['hubot', 'Stack starting redeployment']
        ['hubot', 'development backend_app: Deploying :hammer_and_wrench:']
        ['hubot', 'Deployment taking too long. Run `stack` command to get status update.']
      ]
    )

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
        .reply(200, live_stacks_response)

      nock('https://app.cloud66.com')
        .post("/api/3/stacks/abc-567/deployments")
        .reply(200, @deploy_response)

      nock('https://app.cloud66.com')
        .get("/api/3/stacks/abc-567")
        .reply(200, {
          response: {
            uid: 'abc-567',
            name: 'user app',
            environment: 'development',
            status: 6,
            health: 3
          }
        })

      nock('https://app.cloud66.com')
        .get("/api/3/stacks/abc-567")
        .reply(200, {
          response: {
            uid: 'abc-567',
            name: 'user app',
            environment: 'development',
            status: 1,
            health: 3
          }
        })

      co(() =>
        yield @room.user.say('alice', '@hubot cloud66 redeploy development user app')
        yield new Promise.delay(500)
      )

    it 'responds to redeploy', ->
      expect(@room.messages).to.eql [
        ['alice', '@hubot cloud66 redeploy development user app']
        ['hubot', 'Stack starting redeployment']
        ['hubot', 'development user app: Deploying :hammer_and_wrench:']
        ['hubot', 'development user app: Live :rocket:']
      ]

  context 'redeploy with non_existing stack_name', ->
    beforeEach ->
      nock('https://app.cloud66.com')
        .get('/api/3/stacks.json')
        .reply(200, live_stacks_response)

      co(() =>
        yield @room.user.say('alice', '@hubot cloud66 redeploy development non_existing_app')
        yield new Promise.delay(500)
      )

    it 'responds to deploy', ->
      expect(@room.messages).to.eql [
        ['alice', '@hubot cloud66 redeploy development non_existing_app']
        ['hubot', 'Invalid stack_name']
      ]

  context 'redeploy stack with in-progress deployment', ->
    beforeEach ->
      @deploy_response = {
        response: {
          ok: true,
          message: 'Stack starting redeployment'
        }
      }

      nock('https://app.cloud66.com')
        .get('/api/3/stacks.json')
        .reply(200, deploying_stacks_response)

      co(() =>
        yield @room.user.say('alice', '@hubot cloud66 redeploy development backend_app')
        yield new Promise.delay(1000)
      )

    it('responds to redeploy', () ->
      expect(@room.messages).to.eql [
        ['alice', '@hubot cloud66 redeploy development backend_app']
        ['hubot', 'Stack has in-progress deployment']
      ]
    )
