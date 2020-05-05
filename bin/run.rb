require_relative '../config/environment'

def welcome
    puts "Welcome to our Shopping Database."
end

def user_name
    puts "What is your name?"
    user = gets.chomp
    if user.empty?
        user_name
    else
        return user
    end

end





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
