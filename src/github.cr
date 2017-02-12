require "./github/*"

module Github
  API_URL = "https://api.github.com"

  class Error < Exception
  end

  class UserApi
    def initialize(@token : String)
    end

    def user
      headers = HTTP::Headers{
        "Authorization" => "token #{@token}",
        "Accept"        => "application/vnd.github.v3+json",
      }

      response = HTTP::Client.get("#{API_URL}/user", headers: headers)

      raise Error.new if response.status_code >= 300

      JSON.parse(response.body)
    end
  end

  class Oauth2
    AUTHORIZE_URL = "https://github.com/login/oauth/authorize"
    TOKEN_URL     = "https://github.com/login/oauth/access_token"

    def initialize(@client_id : String, @client_secret : String)
    end

    def authorize_url(redirect_uri : String, scope = nil, state = nil)
      "#{AUTHORIZE_URL}?redirect_uri=#{redirect_uri}&client_id=#{@client_id}&scope=#{scope}&state=#{state}"
    end

    def access_token(code : String, redirect_uri : String, state = nil)
      headers = HTTP::Headers{
        "User-agent" => "CrystalNews Backend",
        "Accept"     => "application/json",
      }

      body = "client_id=#{@client_id}&client_secret=#{@client_secret}&code=#{code}&redirect_uri=#{redirect_uri}&state=#{state}"
      response = HTTP::Client.post(TOKEN_URL, headers: headers, body: body)

      raise Error.new("unable to get access token") if response.status_code >= 300

      JSON.parse(response.body)
    end
  end
end
