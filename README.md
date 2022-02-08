# README

WARNING: deeply experimental and unfinished

## Getting Started

`bundle install`

`EDITOR=vim rails credentials:edit` to open the Rails encrypted credentials file

Add your twitter creds with the below structure:

```
TWITTER:
  API_KEY:
  API_KEY_SECRET:
  BEARER_TOKEN:
```

`echo "[]" > db/log.json` to set up the temporary request log for dev (see [my hacky utilty class](lib/json_libs.rb))

`rails s` like ya do

## Endpoints

To be documented when namespacing is better solidified. Until then, check `routes.rb`

## License

Licensed under [Mozilla Public License 2.0](https://www.mozilla.org/en-US/MPL/2.0/)
