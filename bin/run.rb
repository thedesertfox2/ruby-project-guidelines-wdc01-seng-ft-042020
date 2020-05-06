require_relative '../config/environment'
require_relative './helper.rb'
require 'pry'
def run
    welcome
    user = Client.find_or_create_by(name: user_name)
    command = ''
    while command != 'exit'
        puts "What would you like to do?"
        command = gets.chomp
        case command
            when "start shopping"
                order = Order.create(client_id: user.id)
                input = ''
                while input != 'main menu'
                    puts "Enter a command"
                    input = gets.chomp
                    case input
                    when "list products"
                        arr = Product.all.map do |product|
                            product.name + " - cost: $" + product.cost.to_s + " - stock: " + get_inventory(product.name).count.to_s
                        end
                        puts arr.uniq
                    when /order /
                        if get_inventory(input[6..-1]).length > 0
                            ProductOrder.find_or_create_by(order_id: order.id, product_id: get_inventory(input[6..-1]).pop)
                        else
                            puts "Sorry, we're out of stock or you entered a non-existent product."
                        end
                    when "checkout"
                        total = nil
                        order.product_orders.sum {|productorder| total += productorder.product.cost}
                        total
                        binding.pry
                        puts "Your current order total is #{total}"
                    end
                end
            when "order history"
                puts 'orders'
        end
    end
end

sock = ProductType.find_or_create_by(name: "Sock")
10.times do 
    Product.create(name: "Hanes Low Cut Socks", cost: 5.50, product_type_id: sock.id)
end
run
