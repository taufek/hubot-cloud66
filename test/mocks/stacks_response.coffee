exports.live_stacks_response = {
  response: [
    {
      uid: 'abc-123'
      name: 'frontend_app'
      environment: 'development'
      is_busy: false
      status: 1
      health: 3
    },
    {
      uid: 'abc-345'
      name: 'backend_app'
      environment: 'development'
      is_busy: false
      status: 1
      health: 3
    },
    {
      uid: 'abc-567'
      name: 'user app'
      environment: 'development'
      is_busy: false
      status: 1
      health: 3
    }
  ]
}

exports.deploying_stacks_response = {
  response: [
    {
      uid: 'abc-123'
      name: 'frontend_app'
      environment: 'development'
      is_busy: false
      status: 6
      health: 3
    },
    {
      uid: 'abc-345'
      name: 'backend_app'
      environment: 'development'
      is_busy: false
      status: 6
      health: 3
    },
    {
      uid: 'abc-567'
      name: 'user app'
      environment: 'development'
      is_busy: false
      status: 6
      health: 3
    }
  ]
}
