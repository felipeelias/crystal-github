require "oauth2"

module Github
  class OAuth2
    Host         = "github.com"
    AuthorizeUri = "/login/oauth/authorize"
    TokenUri     = "/login/oauth/access_token"
    UserAgent    = "CrystalGithubClient/#{Github::VERSION}"

    @client_id : String
    @client_secret : String
    @redirect_uri : String

    def initialize(@client_id, @client_secret, @redirect_uri)
      @client = ::OAuth2::Client.new(
        Host,
        @client_id,
        @client_secret,
        redirect_uri: @redirect_uri,
        authorize_uri: AuthorizeUri,
        token_uri: TokenUri
      )
    end

    def authorize_uri(scope = nil, state = nil)
      @client.get_authorize_uri(scope, state)
    end

    def access_token(authorization_code : String)
      @client.get_access_token_using_authorization_code(authorization_code)
    end
  end
end
