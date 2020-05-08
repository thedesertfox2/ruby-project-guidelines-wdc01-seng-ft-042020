require_relative '../config/environment'
require_relative './helper.rb'
require 'pry'

def run
    welcome
    user = Client.find_or_create_by(name: user_name)
    cli_instance = CLI.new(user)
    if user.name.downcase == 'admin'
        admin_logged_in(cli_instance)
    else
        user_logged_in(cli_instance)
    end
end

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

def user_logged_in(cli_instance)
    command = ''
    while command != 'exit'
        puts "What would you like to do? Enter one of the following commands."
        pp ["pending orders", "complete orders", "new order", "order history", "exit"]
        command = gets.chomp
            case command
                when "pending orders"
                    cli_instance.pending_order_menu_logic
                when "complete orders"
                    cli_instance.complete_order_menu_logic
                when "new order"
                    cli_instance.new_order_menu_logic
                when "order history"
                    cli_instance.order_history_menu_logic
                
            end
    end
end

def admin_logged_in(cli_instance)
    command = ''
    while command != 'exit'
        puts "What would you like to do?"
        puts ["see inventory", "add {item category}"]
        command = gets.chomp
        case command
            when "see inventory"
                arr = Product.all.map do |product|
                    product.name + product.cost.to_s + " - stock: " + cli_instance.get_inventory(product.name).count.to_s
                end
                puts arr.uniq
            when /add /
                product_ty = ProductType.find_or_create_by(name: command[4..-1]).id
                puts "What is the name of the item?"
                name = gets.chomp
                quantity = cli_instance.get_quantity
                cost = cli_instance.get_cost
                quantity.times do
                    Product.create(name: name, cost: cost, product_type_id: product_ty)
                end      
            
                
        end
    end
                

end


run