require "test_helper"
require 'webmock/minitest'

class ApiClientFunTest < Minitest::Test

  def test_that_it_has_a_version_number
    refute_nil ::ApiClientFun::VERSION
  end

  def test_it_finds_a_user_by_name
    stub_request(:any, ApiClientFun::USERS_URL).
      to_return(body: '{"users": [
          {"profile": {}, "position": "Intern", "name": "Joe Intern"}
        ]}', status: 200,
      headers: {'Content-Type': 'application/json'})

    expected_user = {
      profile: {},
      position: "Intern",
      name: "Joe Intern"
    }
    assert_equal expected_user, ApiClientFun.find_user_by_name('Joe Intern')
  end

  def test_it_returns_a_profile_by_name
    stub_request(:any, ApiClientFun::USERS_URL).
      to_return(body: '{"users": [
          {"profile": {"species": "Ewok"}, "name": "Dave Ewok"},
          {"profile": {"species": "Zombie"}, "name": "Max Zombie"},
          {"profile": {"species": "Meat Popsicle"}, "name": "Corbin Dallas"}
        ]}', status: 200,
      headers: {'Content-Type': 'application/json'})

    profile = ApiClientFun.profile_for_name('Max Zombie')
    assert_instance_of Hash, profile
    assert_equal 'Zombie', profile[:species]
  end
end
