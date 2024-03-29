# hubot-cloud66

[![Codacy Badge](https://app.codacy.com/project/badge/Grade/515af61eac90499e9dfe07e45ee52fea)](https://www.codacy.com/gh/taufek/hubot-cloud66/dashboard?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=taufek/hubot-cloud66&amp;utm_campaign=Badge_Grade)
![GitHub Action Test](https://github.com/taufek/hubot-cloud66/actions/workflows/test.yml/badge.svg?branch=master)

Hubot for Cloud66

See [`src/cloud66.coffee`](src/cloud66.coffee) for full documentation.

## Requirements

| package         | version  |
|-----------------|----------|
| coffeescript    | >= 1.9   |

## Installation

In hubot project repo, run:

`npm install hubot-cloud66 --save`

Then add **hubot-cloud66** to your `external-scripts.json`:

```json
[
  "hubot-cloud66"
]
```

## Environment Variables

`CLOUD66_ACCESS_TOKEN` = Cloud66 personal access token. Go to [Cloud66 personal tokens page](https://app.cloud66.com/personal_tokens/new) to generate one.

`CLOUD66_DELAY_IN_MS` - Delay in millisecond before start polling Cloud66 for Stack status update after running `redeploy`.

`CLOUD66_INTERVAL_IN_MS` - Interval in millisecond between polling requests for Cloud66 Stack status update.

`CLOUD66_MAX_ATTEMPTS` - Maximum attempts to poll Cloud66 for Stack status update.

`CLOUD66_ENABLE_SLACK_CALLBACK` - Enable Slack callback for interactive buttons. You will need to configure your Slack app with callback url.

## Commands

### Stack Deployment Info

Stack latest deployment info for given environment and stack name.

```bash
user1>> hubot cloud66 deployment development backend_app
hubot>> Here is the latest deployment commit hash for development backend_app
hubot>> Commit https://github.com/taufek/backend_app/commit/5675fcd8f9e6dc534ecf1410c0661c066097e310
```

### Stacks List

Display all available stacks.

```bash
user1>> hubot cloud66 stacks
hubot>>
frontend_app (env: development, uid: abc-123)
backend_app (env: development, uid: abc-345)
user app (env: development, uid: abc-456)
```

### Stack Info/Status

Stack current info for given environment and stack name.

```bash
user1>> hubot cloud66 stack development backend_app
hubot>> development backend_app status: Live 🚀
```

### Stack Redeployment

Redeploy given environment and stack name.

```bash
user1>> hubot cloud66 redeploy development backend_app
hubot>> Stack queued for redeployment
hubot>> development backend_app status: Deploying 🛠️
... few minutes later
hubot>> development backend_app status: Live 🚀
```

### Alias

`c66` is an alias for `cloud66`, so you could also run below

```bash
user1>> hubot c66 stack development backend_app
hubot>> development backend_app status: Live 🚀
```

## Slack Integration

### Message Output

Stack output with Slack callback disabled

![Stack Output without callback](https://i.imgur.com/SxsezGo.png)

Stack output with Slack callback enabled

![Stack Output with callback](https://i.imgur.com/H2k0CsH.png)

### Enabling Slack Callback

Set `CLOUD66_ENABLE_SLACK_CALLBACK` environment variable to true.

Then in your Slack App setup configure your action callback url to point
to `hubot-cloud66` endpoint.

![Stack callback url](https://i.imgur.com/s0psU6P.png)

If your `hubot` already has a router, you can set the action callback url to
your existing endpoint and redirect any post request with Slack callback_id
that starts with `cloud66` to `/hubot/cloud66`.

Below is an example code of hubot router with `/hubot/slack` endpoint that
redirects request to `/hubot/cloud66` endpoint.

```coffeescript
http = require('http')

module.exports = (robot) ->
  robot.router.post '/hubot/slack', (request, response) ->
    data = if request.body.payload? then JSON.parse request.body.payload else request.body

    if data.callback_id.startsWith 'cloud66'
      options = {
        host: request.headers.host,
        path: '/hubot/cloud66',
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Content-Length': JSON.stringify(data).length
        }
      }

    req = http.request options, (res) =>
      res.on 'data', (d) =>
        response.send(d)

    req.on 'error', (error) =>
      console.error(error)

    req.write JSON.stringify(data)
    req.end
```

## NPM Module

[NPM module page](https://www.npmjs.com/package/hubot-cloud66)
