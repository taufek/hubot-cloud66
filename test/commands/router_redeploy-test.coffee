Helper = require('hubot-test-helper')
Promise = require('bluebird')
chai = require 'chai'
co = require 'co'
nock = require 'nock'
http = require('http')

expect = chai.expect
helper = new Helper('../../src/cloud66.coffee')
{ live_stacks_response, deploying_stacks_response } = require '../mocks/stacks_response'
process.env.EXPRESS_PORT = 8080

describe 'POST /hubot/cloud66', ->
  beforeEach ->
    @initialInterval = process.env.CLOUD66_INTERVAL_IN_MS
    @initialDelay = process.env.CLOUD66_INTERVAL_IN_MS
    process.env.CLOUD66_INTERVAL_IN_MS = 100
    process.env.CLOUD66_DELAY_IN_MS = 100
    @room = helper.createRoom({ name: 'room123' })

  afterEach ->
    @room.destroy()
    process.env.CLOUD66_INTERVAL_IN_MS = @initialInterval
    process.env.CLOUD66_DELAY_IN_MS = @initialDelay

  context 'action is redeploy', ->
    beforeEach (done) ->
      data = {
        type: 'interactive_message',
        actions: [
          { name: 'redeploy', type: 'button', value: 'abc-345' }
        ],
        callback_id: 'cloud66',
        team: { id: 'TGUSY1BPZ', domain: 'taufek' },
        channel: { id: 'room123', name: 'room123' },
        user: { id: 'UGTMB157V', name: 'taufek' }
      }
      params = {
        host: 'localhost',
        port: 8080,
        path: '/hubot/cloud66',
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Content-Length': JSON.stringify(data).length
        }
      }

      nock('https://app.cloud66.com')
        .get('/api/3/stacks.json')
        .reply(200, live_stacks_response)

      @deploy_response = {
        response: {
          ok: true,
          message: 'Stack starting redeployment'
        }
      }

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
            status: 6
          }
        })

      nock('https://app.cloud66.com')
        .get("/api/3/stacks/abc-345")
        .reply(200, {
          response: {
            uid: 'abc-345',
            name: 'backend_app',
            environment: 'development',
            status: 6
          }
        })

      nock('https://app.cloud66.com')
        .get("/api/3/stacks/abc-345")
        .reply(200, {
          response: {
            uid: 'abc-345',
            name: 'backend_app',
            environment: 'development',
            status: 1
          }
        })

      req = http.request params, (response) =>
        @response = response
        response.setEncoding('utf8')
        response.on 'data', (data) =>
          @data = data
          setTimeout done, 500

      req.on 'error', (error) ->
        console.error(error)

      req.write JSON.stringify(data)
      req.end

    it 'responds successfully', ->
      expect(@response.statusCode).to.equal(200)
      expect(['OK Dokie', 'Your wish is my command', 'Consider it done', 'Right away']).to.include @data
      expect(@room.messages).to.eql [
        ['hubot', 'Stack starting redeployment']
        ['hubot', 'development backend_app: Deploying :hammer_and_wrench:']
        ['hubot', 'development backend_app: Live :rocket:']
      ]

  context 'action is redeploy and stack has in-progress deployment', ->
    beforeEach (done) ->
      data = {
        type: 'interactive_message',
        actions: [
          { name: 'redeploy', type: 'button', value: 'abc-345' }
        ],
        callback_id: 'cloud66',
        team: { id: 'TGUSY1BPZ', domain: 'taufek' },
        channel: { id: 'room123', name: 'room123' },
        user: { id: 'UGTMB157V', name: 'taufek' }
      }
      params = {
        host: 'localhost',
        port: 8080,
        path: '/hubot/cloud66',
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Content-Length': JSON.stringify(data).length
        }
      }

      nock('https://app.cloud66.com')
        .get('/api/3/stacks.json')
        .reply(200, deploying_stacks_response)

      req = http.request params, (response) =>
        @response = response
        response.setEncoding('utf8')
        response.on 'data', (data) =>
          @data = data
          setTimeout done, 500

      req.on 'error', (error) ->
        console.error(error)

      req.write JSON.stringify(data)
      req.end

    it 'responds successfully', ->
      expect(@response.statusCode).to.equal(200)
      expect(['OK Dokie', 'Your wish is my command', 'Consider it done', 'Right away']).to.include @data
      expect(@room.messages).to.eql [
        ['hubot', 'Stack has in-progress deployment']
      ]
