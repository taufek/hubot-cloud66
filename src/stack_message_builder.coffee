exports.stack_message_builder = (robot, stack) =>
  status = if stack.status > 1 then 'Deploying :hammer_and_wrench:' else 'Live :rocket:'

  if robot.adapterName == 'slack'
    output = {
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
    }
  else
    output = "#{stack.environment} #{stack.name}: #{status}"

