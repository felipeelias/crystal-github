require "../spec_helper"

describe Github::OAuth2 do
  it "returns proper authorize_uri" do
    client = Github::OAuth2.new("id", "secret", "redirect_uri")

    uri = URI.parse(client.authorize_uri(scope: "scope scope", state: "state"))

    uri.host.should eq("github.com")
    uri.query.should match(/client_id=id/)
    uri.query.should match(/redirect_uri=redirect_uri/)
    uri.query.should match(/response_type=code/)

    uri.query.should match(/scope=scope\+scope/)
    uri.query.should match(/state=state/)

    uri.query.should_not match(/client_secret=secret/)
  end
end
