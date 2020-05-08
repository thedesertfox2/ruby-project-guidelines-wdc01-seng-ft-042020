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
        return cost.to_f
    else
        puts "Please enter a valid quantity"
        get_cost
    end
end

def get_quantity
    puts "How many would you like to add?"
    quantity = gets.chomp
    if quantity.to_i > 0
        return quantity.to_i
    else
        puts "Please enter a valid quantity"
        get_quantity
    end
end

def admin_logged_in(user)
    command = ''
    while command != 'exit'
        puts "What would you like to do?"
        puts ["see inventory", "add {item category}"]
        command = gets.chomp
        case command
            when "see inventory"
                arr = Product.all.map do |product|
                    product.name + product.cost.to_s + " - stock: " + get_inventory(product.name).count.to_s
                end
                puts arr.uniq
            when /add /
                product_ty = ProductType.find_or_create_by(name: command[4..-1]).id
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

def pending_order(hash, user)
    puts "Which order would you like to resume? Enter an id number"
    command = gets.chomp
    if command == 'back'
        return user_logged_in(user)
    else
        if command.to_i > 0
            if hash[command.to_i]
                Order.find(command.to_i)
            else
                puts "That was invalid.  Please input order number again."
                pending_order(hash, user)
            end
        else
            puts "That was invalid.  Please input order number again."
            pending_order(hash, user)
        end

    end 
end

def shopping_menu(order, user)
    command = ''
    while command != 'back'
        puts "Enter a command"
        pp ["list products", "order ...", "remove", "checkout", "back"]
        command = gets.chomp
        case command
        when "list products"
            arr = Product.all.map do |product|
                product.name + " - cost: $" + product.cost.to_s + " - stock: " + get_inventory(product.name).count.to_s
            end
            puts arr.uniq
        when /order /
            if get_inventory(command[6..-1]).length > 0
                new_order = ProductOrder.find_or_create_by(order_id: order.id, product_id: get_inventory(command[6..-1]).pop)
                puts "You placed an order for #{new_order.product.name}"
            else
                puts "Sorry, we're out of stock or you entered a non-existent product."
            end
        when "remove"
            hash = {}
            order.product_orders.map {|productorder| hash[productorder.id] = productorder.product.name}
            pp hash
            puts "Please enter the product you'd like to remove by id"
            product_order_id = gets.chomp
            remove_item(product_order_id, hash, order)
            puts "That product has been removed from your cart."
            command = 'back'
        when "checkout"
            total = 0
            order.product_orders.sum {|productorder| total += productorder.product.cost}
            total
            puts "Your current order total is $#{total}. Would you like to proceed with the checkout Y/N?"
            decision = gets.chomp
            if decision == "Y" || decision == "y"
                order.update(status: "complete")
                puts "Your order is now complete with a total of $#{total}."
                command = 'back'
            elsif decision == "N" || decision == "n"
                puts "Okay, check out later then."
                command = 'back'
            end

        end
    end
end

def user_logged_in(user)
    command = ''
    while command != 'exit'
        puts "What would you like to do? Enter one of the following commands."
        pp ["pending orders", "complete orders", "new order", "order history", "exit"]
        command = gets.chomp
            case command
                when "pending orders"
                    order_arr = user.orders.where(status: "pending")
                    hash = {}
                    order_arr.each do |order| 
                        hash[order.id] = order.products.map {|product| product.name + ", cost: $" + product.cost.to_s}
                    end
                    pp hash
                    shopping_menu(pending_order(hash, user), user)
                when "complete orders"
                    order_arr = user.orders.where(status: "complete")
                    hash = {}
                    order_arr.each do |order| 
                        hash[order.id] = order.products.map {|product| product.name + ", cost: $" + product.cost.to_s}
                    end
                    pp hash
                    puts "Enter the order id you'd like to view"
                    order_id = gets.chomp
                    if order_id == 'back'
                        return user_logged_in(user)
                    end
                    return_item(Order.find(order_id))
                when "new order"
                    shopping_menu(Order.create(client_id: user.id, status: "pending"), user)
                when "order history"
                    
                    pending_order_hash = {}
                    complete_order_hash = {}
                    
                    pending_orders = user.orders.select {|order| order.status == 'pending'}
                    complete_orders = user.orders.select {|order| order.status == 'complete'}
                    pending_orders.each do |order| 
                        pending_order_hash[order.id] = order.products.map {|product| product.name + ", cost: $" + product.cost.to_s}
                    end
                    complete_orders.each do |order| 
                        complete_order_hash[order.id] = order.products.map {|product| product.name + ", cost: $" + product.cost.to_s}
                    end
                    puts "Pending Orders"
                    pp pending_order_hash
                    puts "Complete Orders"
                    pp complete_order_hash
                   
            end
    end
end

def remove_item(product_order_id, hash, order)
    if product_order_id.to_i > 0
        if hash[product_order_id.to_i]
            ProductOrder.delete(product_order_id.to_i)
            puts 'That item was removed/returned from your order.'
        end
    else
        puts "Please enter a valid id number"
        return_item(order)
    end
end

def get_inventory(name)
    arr1 = ProductOrder.all.map {|productorder| productorder.product_id }
    arr2 = Product.all.select {|product| product.name.downcase.rstrip == name.downcase.rstrip}
    arr2 = arr2.map {|product| product.id}
    arr2 - arr1
end

def return_item(order)
    hash = {}
    order.product_orders.map {|productorder| hash[productorder.id] = productorder.product.name}
    pp hash
    puts "Please enter the product you'd like to remove by id"
    product_order_id = gets.chomp
    remove_item(product_order_id, hash, order)
end
