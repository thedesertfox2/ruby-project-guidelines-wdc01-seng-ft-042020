require_relative '../config/environment'
require_relative './helper.rb'
require 'pry'



def run
    welcome
    user = Client.find_or_create_by(name: user_name)
    cli_instance = CLI.new(user)
    if user.name.downcase == 'admin'
        puts "\n"
        admin_logged_in(cli_instance)
    else
        puts "\n"
        user_logged_in(cli_instance)
    end
end

def welcome
    puts "Welcome to our Shopping Database.\n".colorize(:cyan)
    sleep 1
end

def user_name
    puts "What is your name?\n".colorize(:cyan)
    user = gets.chomp
    if user.empty?
        user_name
    else
        return user
    end
end

def user_logged_in(cli_instance)
    command = ''
    while command != 'exit'
        puts "What would you like to do? Enter one of the following commands."
        pp ["pending orders", "complete orders", "new order", "order history", "exit"]
        command = gets.chomp
            case command
                when "pending orders"
                    cli_instance.pending_order_menu_logic
                    sleep 2
                when "complete orders"
                    cli_instance.complete_order_menu_logic
                    sleep 2
                when "new order"
                    cli_instance.new_order_menu_logic
                    sleep 2
                when "order history"
                    cli_instance.order_history_menu_logic
                    sleep 2
                
            end
    end
end

def admin_logged_in(cli_instance)
    command = ''
    while command != 'exit'
        puts "What would you like to do?"
        pp ["see inventory", "add {item category}"]
        command = gets.chomp
        case command
            when "see inventory"
                cli_instance.see_inventory
            when /add /
                cli_instance.add_item
            
                
        end
    end
                

end


run