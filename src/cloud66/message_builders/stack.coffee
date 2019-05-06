exports.stack_message_builder = (robot, stack, showButton = false) ->
  isLive = stack.status == 1
  status = if isLive then 'Live :rocket:' else 'Deploying :hammer_and_wrench:'

  if robot.adapterName == 'slack'
    environmentEmoji = if stack.environment.startsWith 'prod' then ':earth_asia:' else ':globe_with_meridians:'
    output = {
      attachments: [
        {
          title: stack.name,
          color: 'good',
          fallback: "#{stack.name}, environment: #{stack.environment}, status: #{status}",
          fields: [
            {
              title: 'Environment',
              value: "#{stack.environment} #{environmentEmoji}",
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
    }

    if process.env.CLOUD66_ENABLE_SLACK_CALLBACK == 'true' && isLive
      output.attachments.push(
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
      )

    output
  else
    output = "#{stack.environment} #{stack.name}: #{status}"

