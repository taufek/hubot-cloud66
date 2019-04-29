exports.stack_message_builder = (robot, stack) =>
  status = if stack.status > 1 then 'Deploying :hammer_and_wrench:' else 'Live :rocket:'

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
  else
    output = "#{stack.environment} #{stack.name}: #{status}"

