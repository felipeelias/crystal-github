# crystal-github

[![Build Status](https://travis-ci.org/felipeelias/crystal-github.svg?branch=master)](https://travis-ci.org/felipeelias/crystal-github)

Github API wrapper in [Crystal](https://crystal-lang.org)! (work in progress)

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  github:
    github: felipeelias/crystal-github
    version: ~> 0.1.0
```

## Usage

On your application code, require it with:

```crystal
require "github"
```

### OAuth2 Flow

For now, this client only supports OAuth2 flow to make requests to Github API. To get this working, you need to register a new [`application`](https://github.com/settings/applications/new) and setup the proper attributes.

```crystal
oauth2 = Github::OAuth2.new(client_id, client_secret, redirect_uri)
```

With that, you can build the `authorization_uri` and redirect your users to that

```crystal
oauth2.authorize_uri
# => https://github.com/login/oauth/authorize...
```

If the user authorizes your application, you should be redirected back to the `redirect_uri` that you set up previously, with a `code` parameter in the URI

```crystal
# if you're using kemal
code = env.params.query["code"]

token = oauth2.access_token(code)
# => OAuth2::AccessToken is returned

token.access_token
# => "53gdf31mnv..."
```

You can then use the `access_token` to authorize users with other API requests.

### Users API

**NOTE: subject to change**

```crystal
api = Github::UserApi.new(token.access_token)
user = api.user
# => {"login" => ..., "avatar_url" => ...}
```

## Development

Run tests with:

    crystal spec

You can test it locally with other apps by adding it to your `shards.yml`

```yaml
dependencies:
  github:
    path: path/to/crystal-github
```

## Contributing

1. Create an issue on Github **first**, describing the feature or fix you'd like to add.
2. If nobody is working on the issue, feel free to fork and send a pull-request

## Contributors

- [felipeelias](https://github.com/felipeelias) Felipe Philipp - creator, maintainer
