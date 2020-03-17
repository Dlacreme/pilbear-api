# Pilbear API


## Installation

`$ shards install`
`$ crystal sam.cr -- db:setup`
`$ chmod +x ./dev/*.sh`

## Dev mode

*Install sentry manually* https://github.com/samueleaton/sentry
`$ curl -fsSLo- https://raw.githubusercontent.com/samueleaton/sentry/master/install.cr | crystal eval`
`$ chmod +x ./dev/dev.sh`
`$ ./dev/dev.sh`

## Contribute

`$ crystal sam.cr -- generate:migration CreateContact`: create new migration

## Development
