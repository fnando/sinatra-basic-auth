require "test_helper"

class SampleAppTest < Test::Unit::TestCase
  def test_without_authentication
    get "/"
    assert_equal 401, last_response.status
  end

  def test_with_bad_credentials
    get "/", {}, {"HTTP_AUTHORIZATION" => credentials("invalid", "credentials")}
    assert_equal 401, last_response.status
  end

  def test_with_valid_credentials
    get "/", {}, {"HTTP_AUTHORIZATION" => credentials("john", "test")}
    assert_equal 200, last_response.status
    assert_equal "restricted content", last_response.body
  end

  def test_require_valid_credentials_for_different_realms
    get "/", {}, {"HTTP_AUTHORIZATION" => credentials("john", "test")}
    get "/myapp"
    assert_equal 401, last_response.status
  end

  def test_with_valid_credentials_for_different_realm
    get "/myapp", {}, {"HTTP_AUTHORIZATION" => credentials("mary", "test")}
    assert_equal 200, last_response.status
    assert_equal "restricted content for MyApp", last_response.body
  end

  private
  def credentials(username, password)
    "Basic " + Base64.encode64("#{username}:#{password}")
  end
end
