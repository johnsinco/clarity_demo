require "api_client_fun/version"
require 'faraday'
require 'faraday_middleware'

module ApiClientFun

  USERS_URL = "https://blooming-savannah-20593.herokuapp.com/api/users"

  def self.profile_for_name(user_name)
    user = self.find_user_by_name(user_name)
    return user && user[:profile]
  end

  def self.find_user_by_name(user_name)
    all_users = connection.get
    all_users.body[:users].find do |user|
      user[:name] == user_name
    end
  end

  def self.connection
    @conn ||= Faraday.new USERS_URL do |conn|
      conn.response :raise_error
      conn.response :json, :parser_options => { :symbolize_names => true }
      conn.adapter Faraday.default_adapter
    end
  end

end
