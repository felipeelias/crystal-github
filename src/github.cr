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
end
