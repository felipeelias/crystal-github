require "http/client"
require "json"

module Github
  class OAuth2
    Host         = "github.com"
    AuthorizeUri = "/login/oauth/authorize"
    TokenUri     = "/login/oauth/access_token"

    AcceptHeader = "application/json"
    UserAgent    = "CrystalGithubClient/#{Github::VERSION}"
    Scheme       = "https"

    class AccessToken
      JSON.mapping({
        "access_token" => String,
        "token_type"   => String,
        "scope"        => String,
      })
    end

    class AccessTokenError < Exception
    end

    @client_id : String
    @client_secret : String
    @redirect_uri : String

    def initialize(@client_id, @client_secret, @redirect_uri)
    end

    def authorize_uri(scope = nil, state = nil)
      uri = URI.new(Scheme, Host, nil, AuthorizeUri)

      uri.query = HTTP::Params.build do |form|
        form.add "client_id", @client_id
        form.add "redirect_uri", @redirect_uri
        form.add "response_type", "code"
        form.add "scope", scope unless scope.nil?
        form.add "state", state unless state.nil?
      end

      uri.to_s
    end

    def access_token(authorization_code : String, scope = nil, state = nil)
      uri = URI.new(Scheme, Host, nil, TokenUri)

      uri.query = HTTP::Params.build do |form|
        form.add "client_id", @client_id
        form.add "client_secret", @client_secret
        form.add "redirect_uri", @redirect_uri
        form.add "code", authorization_code
        form.add "scope", scope unless scope.nil?
        form.add "state", state unless state.nil?
      end

      headers = HTTP::Headers{
        "User-agent" => UserAgent,
        "Accept"     => AcceptHeader,
      }

      response = HTTP::Client.post(uri, headers: headers)

      case response.status_code
      when 200..299
        AccessToken.from_json(response.body)
      else
        raise AccessTokenError.new("Status Code: #{response.status_code} / #{response.body}")
      end
    end
  end
end
