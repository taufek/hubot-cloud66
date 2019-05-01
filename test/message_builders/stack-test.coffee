chai = require 'chai'
expect = chai.expect

{ stack_message_builder } = require '../../src/cloud66/message_builders/stack.coffee'

describe 'stack_message_builder', ->
  context 'slack adapter', ->
    beforeEach ->
      @robot = {
        adapterName: 'slack'
      }

    context 'live status', () ->
      beforeEach ->
        @stack = {
          name: 'backend_app',
          environment: 'development',
          status: 1
        }

        @expectedStatus = 'Live :rocket:'
        @expectedEnvironment = 'development :globe_with_meridians:'

      it 'returns slack message', ->
        output = stack_message_builder(@robot, @stack)
  
        expect(output).to.eql expectedSlackOutput(@stack, @expectedStatus, @expectedEnvironment)

    context 'deploying status', () ->
      beforeEach ->
        @stack = {
          name: 'backend_app',
          environment: 'development',
          status: 6
        }

        @expectedStatus = 'Deploying :hammer_and_wrench:'
        @expectedEnvironment = 'development :globe_with_meridians:'

      it 'returns slack message', ->
        output = stack_message_builder(@robot, @stack)

        expect(output).to.eql expectedSlackOutput(@stack, @expectedStatus, @expectedEnvironment)

    context 'production environment', () ->
      beforeEach ->
        @stack = {
          name: 'backend_app',
          environment: 'production',
          status: 1
        }

        @expectedStatus = 'Live :rocket:'
        @expectedEnvironment = 'production :earth_asia:'

      it 'returns slack message', ->
        output = stack_message_builder(@robot, @stack)

        expect(output).to.eql expectedSlackOutput(@stack, @expectedStatus, @expectedEnvironment)

    expectedSlackOutput = (stack, status, environment) ->
      attachments: [
        {
          title: stack.name,
          color: 'good',
          fallback: "#{stack.name}, environment: #{stack.environment}, status: #{status}",
          fields: [
            {
              title: 'Environment',
              value: environment,
              short: true,
            },
            {
              title: 'Status',
              value: status,
              short: true,
            }
          ]
        }
      ]

  context 'other adapter', ->
    beforeEach ->
      @robot = {
        adapterName: ''
      }

    context 'live status', () ->
      beforeEach ->
        @stack = {
          name: 'backend_app',
          environment: 'development',
          status: 1
        }

        @expectedStatus = 'Live :rocket:'

      it 'returns slack message', ->
        output = stack_message_builder(@robot, @stack)

        expect(output).to.eql expectedOtherOutput(@stack, @expectedStatus)

    context 'live status', () ->
      beforeEach ->
        @stack = {
          name: 'backend_app',
          environment: 'development',
          status: 6
        }

        @expectedStatus = 'Deploying :hammer_and_wrench:'

      it 'returns slack message', ->
        output = stack_message_builder(@robot, @stack)

        expect(output).to.eql expectedOtherOutput(@stack, @expectedStatus)

    expectedOtherOutput = (stack, status) ->
      output = "#{stack.environment} #{stack.name}: #{status}"
