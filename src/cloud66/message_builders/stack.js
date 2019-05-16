exports.stack_message_builder = (robot, stack) => {
  const isLive = stack.status == 1
  const status = isLive ? 'Live :rocket:' : 'Deploying :hammer_and_wrench:'
  let output

  if (robot.adapterName == 'slack') {
    const environmentEmoji = stack.environment.startsWith('prod') ? ':earth_asia:' : ':globe_with_meridians:'

    output = {
      attachments: [
        {
          title: stack.name,
          color: 'good',
          fallback: `${stack.name}, environment: ${stack.environment}, status: ${status}`,
          fields: [
            {
              title: 'Environment',
              value: `${stack.environment} ${environmentEmoji}`,
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

    if (process.env.CLOUD66_ENABLE_SLACK_CALLBACK == 'true' && isLive) {
      output.attachments.push(
        {
          text: 'What do you want to do?',
          fallback: 'You are unable to perform an action',
          callback_id: 'cloud66',
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
                text: `This will deploy ${stack.environment} ${stack.name}.`,
                ok_text: 'Deploy away!',
                dismiss_text: 'No'
              }
            }
          ]
        }
      )
    }
  } else {
    output = `${stack.environment} ${stack.name}: ${status}`
  }

  return output
}
