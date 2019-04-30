# hubot-cloud66

[![CircleCI](https://circleci.com/gh/taufek/hubot-cloud66.svg?style=svg)](https://circleci.com/gh/taufek/hubot-cloud66)

Hubot for Cloud66

See [`src/cloud66.coffee`](src/cloud66.coffee) for full documentation.

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

`CLOUD66_ACCESS_TOKEN` = Cloud66 personal access token. Go to https://app.cloud66.com/personal_tokens/new to generate one.

`CLOUD66_DELAY_IN_MS` - Delay in millisecond before start polling Cloud66 for Stack status update after running `redeploy`.

`CLOUD66_INTERVAL_IN_MS` - Interval in millisecond between polling requests for Cloud66 Stack status update.

`CLOUD66_MAX_ATTEMPTS` - Maximum attempts to poll Cloud66 for Stack status update.

## Commands

### Stacks List

Display all available stacks.

```
user1>> hubot cloud66 stacks
hubot>> 
frontend_app (env: development, uid: abc-123)
backend_app (env: development, uid: abc-345)
user app (env: development, uid: abc-456)
```

### Stack Redeployment

Redeploy given environment and stack name.

```
user1>> hubot cloud66 redeploy development backend_app
hubot>> Stack queued for redeployment
hubot>> development backend_app status: Deploying 🛠️
... few minutes later
hubot>> development backend_app status: Live 🚀
```

### Stack Info/Status

Stack current info for given environment and stack name.

```
user1>> hubot cloud66 stack development backend_app
hubot>> development backend_app status: Live 🚀
```

### Alias

`c66` is an alias for `cloud66`, so you could also run below

```
user1>> hubot c66 stack development backend_app
hubot>> development backend_app status: Live 🚀
```

## NPM Module

https://www.npmjs.com/package/hubot-cloud66
