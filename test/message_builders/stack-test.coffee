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

  context 'slack adapter with callback enabled', ->
    beforeEach ->
      @initialSlackCallback = process.env.CLOUD66_ENABLE_SLACK_CALLBACK
      process.env.CLOUD66_ENABLE_SLACK_CALLBACK = 'true'
      @robot = {
        adapterName: 'slack'
      }

    afterEach ->
      process.env.CLOUD66_ENABLE_SLACK_CALLBACK = @initialSlackCallback

    context 'live status', () ->
      beforeEach ->
        @stack = {
          name: 'backend_app',
          environment: 'development',
          status: 1
        }

        @expectedStatus = 'Live :rocket:'
        @expectedEnvironment = 'development :globe_with_meridians:'

      it 'returns slack message with buttons', ->
        output = stack_message_builder(@robot, @stack)

        expect(output).to.eql expectedSlackWithCallbackOutput(@stack, @expectedStatus, @expectedEnvironment)

    context 'deploying status', () ->
      beforeEach ->
        @stack = {
          name: 'backend_app',
          environment: 'development',
          status: 6
        }

        @expectedStatus = 'Deploying :hammer_and_wrench:'
        @expectedEnvironment = 'development :globe_with_meridians:'

      it 'returns slack message without buttons', ->
        output = stack_message_builder(@robot, @stack)

        expect(output).to.eql expectedSlackOutput(@stack, @expectedStatus, @expectedEnvironment)

  expectedOtherOutput = (stack, status) ->
    output = "#{stack.environment} #{stack.name}: #{status}"

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

  expectedSlackWithCallbackOutput = (stack, status, environment) ->
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
      },
      {
        text: 'What do you want to do?',
        fallback: 'You are unable to perform an action',
        callback_id: 'cloud_66_deployment',
        color: '#3AA3E3',
        attachment_type: 'default',
        actions: [
          {
            name: 'stack',
            text: 'View stack info',
            style: 'good',
            type: 'button',
            value: stack.uid
          },
          {
            name: 'deployment',
            text: 'View stack latest deployment',
            style: 'good',
            type: 'button',
            value: stack.uid
          },
          {
            name: 'redeploy',
            text: 'Redeploy stack',
            style: 'good',
            type: 'button',
            value: stack.uid,
            confirm: {
              title: 'Are you sure?',
              text: "This will deploy #{stack.environment} #{stack.name}.",
              ok_text: 'Deploy away!',
              dismiss_text: 'No'
            }
          }
        ]
      }
    ]
