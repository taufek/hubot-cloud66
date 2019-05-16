exports.deployment_message_builder = (robot, deployment) => {
  let output

  if (robot.adapterName == 'slack') {
    output = {
      attachments: [
        {
          color: 'good',
          fallback: `Commit: ${deployment.commit_url}`,
          actions: [
            {
              type: 'button',
              text: `${deployment.git_hash.substr(0, 8)}`,
              url: `${deployment.commit_url}`
            }
          ]
        }
      ]
    }
  } else {
    output = `Commit ${deployment.commit_url}`
  }

  return output
}

