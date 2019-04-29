chai = require 'chai'
expect = chai.expect

{ stack_message_builder } = require '../src/stack_message_builder.coffee'

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

      it 'returns slack message', ->
        output = stack_message_builder(@robot, @stack)
  
        expect(output).to.eql expectedSlackOutput(@stack, @expectedStatus)

    context 'deploying status', () ->
      beforeEach ->
        @stack = {
          name: 'backend_app',
          environment: 'development',
          status: 6
        }

        @expectedStatus = 'Deploying :hammer_and_wrench:'

      it 'returns slack message', ->
        output = stack_message_builder(@robot, @stack)

        expect(output).to.eql expectedSlackOutput(@stack, @expectedStatus)

    expectedSlackOutput = (stack, status) =>
      attachments: [
        {
          title: stack.name,
          color: 'good',
          fallback: "#{stack.name}, environment: #{stack.environment}, status: #{status}",
          fields: [
            {
              title: 'Environment',
              value: stack.environment,
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

    expectedOtherOutput = (stack, status) =>
      output = "#{stack.environment} #{stack.name}: #{status}"
