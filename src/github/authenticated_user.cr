module Github
  class User
    JSON.mapping(
      avatar_url: String,
      bio: String?,
      blog: String,
      company: String,
      created_at: String,
      email: String?,
      events_url: String,
      followers: Int32,
      followers_url: String,
      following: Int32,
      following_url: String,
      gists_url: String,
      gravatar_id: String,
      hireable: Bool?,
      html_url: String,
      id: Int32,
      location: String,
      login: String,
      name: String,
      organizations_url: String,
      public_gists: Int32,
      public_repos: Int32,
      received_events_url: String,
      repos_url: String,
      site_admin: Bool,
      starred_url: String,
      subscriptions_url: String,
      type: String,
      updated_at: String,
      url: String,
    )
  end

  class AuthenticatedUser
    def initialize(@token : String)
    end

    def get : User
      headers = HTTP::Headers{
        "Authorization" => "token #{@token}",
        "Accept"        => "application/vnd.github.v3+json",
      }

      response = HTTP::Client.get("#{API_URL}/user", headers: headers)

      raise Error.new if response.status_code >= 300

      User.from_json(response.body)
    end
  end
end
