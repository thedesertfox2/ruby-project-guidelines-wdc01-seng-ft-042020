require_relative '../config/environment'


class CLI

    attr_accessor :user, :command, :order

    def initialize(user)
        @user = user
        @command = ''
        @order = nil
    end

#################################AdminFunctions##########################################
    def see_inventory
        puts 
        arr = Product.all.map do |product|
            product.name + " - cost: $" + product.cost.to_s + " - stock: " + ProductOrder.get_inventory(product.name).count.to_s
        end
        puts arr.uniq
        puts "\n\n"
    end

    def exit_menu(string)
        string == 'back' || string == 'exit'
    end

    def add_item 
        product_type = ProductType.find_or_create_by(name: command[4..-1]).id
        puts "What is the brand name of the item?\n\n".colorize(:cyan)
        name = gets.chomp
        if self.exit_menu(name)
            return
        end
        quantity = self.get_quantity
        if quantity == nil
            return
        end
        cost = self.get_cost
        if cost == nil
            return 
        end
        quantity.times do
            Product.create(name: name, cost: cost, product_type_id: product_type)
        end
        puts "We added #{quantity} of #{name} to your stock with a cost of $#{cost} per unit. \n\n".colorize(:cyan)      
    end

    def get_cost
        puts "How much does it cost?\n\n".colorize(:cyan)
        cost = gets.chomp
        if self.exit_menu(cost)
            return
        elsif cost.to_f > 0
            return cost.to_f
        else
            puts "Please enter a valid quantity \n\n".colorize(:cyan)
            self.get_cost
        end
    end

    def get_quantity
        puts "How many would you like to add?\n\n".colorize(:cyan)
        quantity = gets.chomp
        if self.exit_menu(quantity)
            return
        elsif quantity.to_i > 0
            return quantity.to_i
        else
            puts "Please enter a valid quantity\n\n".colorize(:cyan)
            self.get_quantity
        end
    end

################################## User Logged In Functions ##############################

    def pending_order_menu_logic
        pending_order_hash = self.user.generate_pending_orders
        pending_order_hash = self.delete_empty_order(pending_order_hash)
        pp pending_order_hash
        if pending_order_hash.length > 0
            order = self.select_pending_order(pending_order_hash)
            if order != nil
                self.order = order
                self.shopping_menu
            end
        else
            puts "You have no pending orders."
        end
    end

    def select_pending_order(hash)
        puts "Which order would you like to resume? Enter an id number. \n\n"
        command = gets.chomp 
        puts "\n"
        if self.exit_menu(command)
            return
        else
            if command.to_i > 0
                if hash[command.to_i]
                    Order.find(command.to_i)
                else
                    puts "That was invalid.  Please input order number again."
                    self.select_pending_order(hash)
                end
            else
                puts "That was invalid.  Please input order number again."
                self.select_pending_order(hash)
            end
        end 
    end

    def delete_empty_order(hash)
        empty_orders = hash.select {|k, v| v.empty?}
        empty_orders.each {|k, v| Order.delete(k)}
        hash.select {|k, v| v.length > 0}
    end

    def complete_order_menu_logic
        order_arr = self.user.orders.where(status: "complete")
        order_hash = {}
        order_arr.each do |order| 
            order_hash[order.id] = order.products.map {|product| product.name + ", cost: $" + product.cost.to_s}
        end
        pp order_hash
        puts "Enter the order id you'd like to view"
        order_id = gets.chomp
        if self.exit_menu(order_id)
            return
        elsif order_id.to_i > 0
            self.order = Order.find(order_id)
            self.return_item(self.order.id)
        else
            puts "invalid"
            self.complete_order_menu_logic
        end
        
    end

    def remove_item(product_order_id, hash, order_id)
        if product_order_id.to_i > 0
            if hash[product_order_id.to_i]
                ProductOrder.delete(product_order_id.to_i)
                self.order = Order.find(order_id)
                puts 'That item was removed/returned from your order.'
            end
        else
            puts "Please enter a valid id number"
            self.return_item(order_id)
        end
    end

    def new_order_menu_logic
        self.order = Order.create(client_id: self.user.id, status: "pending")
        self.shopping_menu
    end

    def order_history_menu_logic
        pending_order_hash = {}
        complete_order_hash = {}
        pending_orders = self.user.orders.select {|order| order.status == 'pending'}
        complete_orders = self.user.orders.select {|order| order.status == 'complete'}
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

################################## Shopping Menu ############################################

    def list_products
        puts "\n"
        product_arr = Product.all.map do |product|
            product.name + " - cost: $" + product.cost.to_s + " - stock: " + ProductOrder.get_inventory(product.name).count.to_s
        end
        puts product_arr.uniq
        sleep 2
    end

    def order_product(command)
        puts "\n"
        if ProductOrder.get_inventory(command[6..-1]).length > 0
            new_order = ProductOrder.find_or_create_by(order_id: self.order.id, product_id: ProductOrder.get_inventory(command[6..-1]).pop)
            puts "You placed an order for #{new_order.product.name}"
        else
            puts "Sorry, we're out of stock or you entered a non-existent product."
        end
        sleep 2
    end
    
    def remove_from_cart(order_id)
        puts "\n"
        product_order_hash = {}
        self.order = Order.find(order_id)
        self.order.product_orders.map {|productorder| product_order_hash[productorder.id] = productorder.product.name}
        pp product_order_hash
        puts "Please enter the product you'd like to remove by id"
        product_order_id = gets.chomp
        if exit_menu(product_order_id)
            return
        end
        puts "\n"
        self.remove_item(product_order_id, product_order_hash, order_id)
        sleep 2
    end
    
    def checkout
        puts "\n"
        total_price = 0
        self.order.product_orders.sum {|productorder| total_price += productorder.product.cost}
        total_price
        puts "Your current order total is $#{total_price}. Would you like to proceed with the checkout Y/N?"
        decision = gets.chomp
        puts "\n"
        if decision == "Y" || decision == "y"
            self.order.update(status: "complete")
            puts "Your order is now complete with a total of $#{total_price}."
            return 1
        elsif decision == "N" || decision == "n"
            puts "Okay, check out later then."
        end
        sleep 2
    end

    def shopping_menu
        command = ''
        while command != 'back'
            puts "Enter a command".colorize(:cyan)
            pp ["list products", "order ...", "remove", "checkout", "back"]
            command = gets.chomp
            case command
            when "list products"
                self.list_products
            when /order /
                self.order_product(command)
            when "remove"
                self.remove_from_cart(self.order.id)
            when "checkout"
                if self.checkout == 1
                    command = 'back'
                end
            end
        end
    end

    def return_item(order_id)
        product_order_hash = {}
        self.order.product_orders.map {|productorder| product_order_hash[productorder.id] = productorder.product.name}
        pp product_order_hash
        puts "Please enter the product you'd like to remove by id".colorize(:cyan)
        product_order_id = gets.chomp
        puts "\n"
        if self.exit_menu(product_order_id)
            return
        end
        sleep 2
        self.remove_item(product_order_id, product_order_hash, product_order_id)
    end
end
