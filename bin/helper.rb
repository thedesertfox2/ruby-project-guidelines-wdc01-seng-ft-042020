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

def get_cost
    puts "How much does it cost?"
    cost = gets.chomp
    if cost.to_f > 0
        return cost
    else
        puts "Please enter a valid quantity"
        get_cost.to_f
    end
end

def get_quantity
    puts "How many would you like to add?"
    quantity = gets.chomp
    if quantity.to_i > 0
        return quantity
    else
        puts "Please enter a valid quantity"
        get_quantity.to_i
    end
end

def admin_logged_in(user)
    command = ''
    while command != 'exit'
        puts "What would you like to do?"
        command = gets.chomp
        case command
            when "see inventory"
                arr = Product.all.map do |product|
                    product.name + product.cost.to_s + " - stock: " + get_inventory(product.name).count.to_s
                end
                puts arr.uniq
            when "add stock"
                puts "Which item would you like to add?"
                input = ''
                input = gets.chomp
                case input 
                    when /add /
                        product_ty = ProductType.find_or_create_by(name: input[4..-1]).id
                        puts "What is the name of the item?"
                        name = gets.chomp
                       
                        quantity = get_quantity
                        cost = get_cost
                        quantity.times do
                        Product.create(name: name, cost: cost, product_type_id: product_ty)
                        end
                            
                    else
                        puts "Sorry that was not a valid command"
        
                end
        end
    end
                

end

def pending_order(hash)
    puts "Which order would you like to resume? Enter an id number"
    input = gets.chomp
    if input.to_i > 0
        if hash[input.to_i]
            Order.find(input.to_i)
        end
    else
        puts "That was invalid.  Please input order number again."
        pending_order
    end
end

def shopping_menu(order)
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
        total = 0
        order.product_orders.sum {|productorder| total += productorder.product.cost}
        total
        puts "Your current order total is $#{total}. Would you like to proceed with the checkout Y/N?"
        decision = gets.chomp
        if decision == "Y" || decision == "y"
            order.update(status: "complete")
            puts "Your order is now complete with a total of $#{total}."
            input = 'main menu'
        elsif decision == "N" || decision == "n"
            order.update(status: "pending")
            puts "Okay, check out later then."
            input = 'main menu'
        end

    end
end
end

def user_logged_in(user)
    command = ''
    while command != 'exit'
        puts "What would you like to do?"
        command = gets.chomp
        case command
            when "pending orders"
                order_arr = user.orders.where(status: "pending")
                hash = {}
                order_arr.each do |order| 
                    hash[order.id] = order.products.map {|product| product.name + ", cost: $" + product.cost.to_s}
                end
                pp hash
                shopping_menu(pending_order(hash))
            when "new order"
                shopping_menu(Order.create(client_id: user.id, status: "new"))
            when "order history"
                new_order_hash = {}
                pending_order_hash = {}
                complete_order_hash = {}
                new_orders = user.orders.select {|order| order.status == 'new'}
                pending_orders = user.orders.select {|order| order.status == 'pending'}
                complete_orders = user.orders.select {|order| order.status == 'complete'}
                new_orders.each do |order| 
                    new_order_hash[order.id] = order.products.map {|product| product.name + ", cost: $" + product.cost.to_s}
                end
                pending_orders.each do |order| 
                    pending_order_hash[order.id] = order.products.map {|product| product.name + ", cost: $" + product.cost.to_s}
                end
                complete_orders.each do |order| 
                    complete_order_hash[order.id] = order.products.map {|product| product.name + ", cost: $" + product.cost.to_s}
                end
                puts "New Orders"
                pp new_order_hash
                puts "Pending Orders"
                pp pending_order_hash
                puts "Complete Orders"
                pp complete_order_hash
        end
    end
end


def get_inventory(name)
    arr1 = ProductOrder.all.map {|productorder| productorder.product_id }
    arr2 = Product.all.select {|product| product.name.downcase == name.downcase}
    arr2 = arr2.map {|product| product.id}
    arr2 - arr1
end
