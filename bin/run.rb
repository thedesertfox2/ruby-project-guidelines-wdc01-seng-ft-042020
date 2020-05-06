require_relative '../config/environment'
require_relative './helper.rb'
require 'pry'
def run
    welcome
    user = Client.find_or_create_by(name: user_name)
    if user.name.downcase == 'admin'
        admin_logged_in(user)
    else
        user_logged_in(user)
    end
end

run
