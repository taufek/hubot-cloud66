Helper = require('hubot-test-helper')
Promise = require('bluebird')
chai = require 'chai'
co = require 'co'
nock = require 'nock'
http = require('http')

expect = chai.expect
helper = new Helper('../../src/cloud66.coffee')
{ live_stacks_response } = require '../mocks/stacks_response.coffee'
process.env.EXPRESS_PORT = 8080

describe 'POST /hubot/cloud66', ->
  beforeEach ->
    @room = helper.createRoom({ name: 'room123' })

  afterEach ->
    @room.destroy()

  context 'action is stack', ->
    beforeEach (done) ->
      data = {
        type: 'interactive_message',
        actions: [
          { name: 'stack', type: 'button', value: 'abc-345' }
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

      req = http.request params, (response) =>
        @response = response
        response.setEncoding('utf8')
        response.on 'data', (data) =>
          @data = data
          setTimeout done, 100

      req.on 'error', (error) ->
        console.error(error)

      req.write JSON.stringify(data)
      req.end

    it 'responds successfully', ->
      expect(@response.statusCode).to.equal(200)
      expect(['OK Dokie', 'Your wish is my command', 'Consider it done', 'Right away']).to.include @data
      expect(@room.messages).to.eql [
        ['hubot', 'development backend_app: Live :rocket:']
      ]
