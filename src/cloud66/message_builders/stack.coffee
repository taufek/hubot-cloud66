exports.stack_message_builder = (robot, stack, showButton = false) ->
  isLive = stack.status == 1

  status = switch stack.status
    when 0 then 'Queued :hourglass_flowing_sand:'
    when 1 then 'Live :rocket:'
    when 2 then 'Failed :rotating_light:'
    when 3 then 'Analysing :memo:'
    when 4 then 'Analysed :white_check_mark:'
    when 5 then 'Queued for deploy :vertical_traffic_light:'
    when 6 then 'Deploying :hammer_and_wrench:'
    when 7 then 'Terminal failure :scream:'
    else 'Unknown :question:'

  if robot.adapterName == 'slack'
    environmentEmoji = if stack.environment.startsWith 'prod' then ':earth_asia:' else ':globe_with_meridians:'
    color = switch stack.health
      when 0 then 'warning'
      when 1 then 'warning'
      when 2 then 'warning'
      when 3 then 'good'
      when 4 then 'danger'
      else 'warning'

    output = {
      attachments: [
        {
          title: stack.name,
          color: color,
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
