require_relative '../config/environment'

def run
    welcome
    user = Client.find_or_create_by(name: user_name)
    puts "What would you like to do?"
    command = gets.chomp
    case command
        when "place order"
            #
        when "list products"
        when
end

run
