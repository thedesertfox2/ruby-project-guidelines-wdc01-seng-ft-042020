require_relative '../config/environment'
class CLI

    attr_accessor :user, :command, :order

    def initialize(user)
        @user = user
        @command = ''
        @order = nil
    end

#################################AdminFunctions##########################################

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

################################## User Logged In Functions ##############################

    def pending_order_menu_logic
        order_arr = self.user.orders.where(status: "pending")
        hash = {}
        order_arr.each do |order| 
            hash[order.id] = order.products.map {|product| product.name + ", cost: $" + product.cost.to_s}
        end
        pp hash
        order = self.pending_order(hash)
        if order != nil
            self.order = order
            self.shopping_menu
        end
    end

    def pending_order(hash)
        puts "Which order would you like to resume? Enter an id number."
        command = gets.chomp
        if command == 'back'
            return
        else
            if command.to_i > 0
                if hash[command.to_i]
                    Order.find(command.to_i)
                else
                    puts "That was invalid.  Please input order number again."
                    self.pending_order(hash)
                end
            else
                puts "That was invalid.  Please input order number again."
                self.pending_order(hash)
            end
        end 
    end

    def complete_order_menu_logic
        order_arr = self.user.orders.where(status: "complete")
        hash = {}
        order_arr.each do |order| 
            hash[order.id] = order.products.map {|product| product.name + ", cost: $" + product.cost.to_s}
        end
        pp hash
        puts "Enter the order id you'd like to view"
        order_id = gets.chomp
        if order_id == 'back'
            return
        elsif order_id.to_i > 0
            self.order = Order.find(order_id)
            self.return_item
        else
            puts "invalid"
            self.complete_order_menu_logic
        end
        
    end

    def remove_item(product_order_id, hash)
        if product_order_id.to_i > 0
            if hash[product_order_id.to_i]
                ProductOrder.delete(product_order_id.to_i)
                puts 'That item was removed/returned from your order.'
            end
        else
            puts "Please enter a valid id number"
            self.return_item
        end
    end

    def new_order_menu_logic
        self.order = Order.create(client_id: self.user.id, status: "pending")
        self.shopping_menu
    end

    # def order_history_menu_logic
    #     pending_order_hash = {}
    #     complete_order_hash = {}
        
    #     pending_orders = self.user.orders.select {|order| order.status == 'pending'}
    #     complete_orders = self.user.orders.select {|order| order.status == 'complete'}
    #     pending_orders.each do |order| 
    #         pending_order_hash[self.order.id] = order.products.map {|product| product.name + ", cost: $" + product.cost.to_s}
    #     end
    #     complete_orders.each do |order| 
    #         complete_order_hash[self.order.id] = order.products.map {|product| product.name + ", cost: $" + product.cost.to_s}
    #     end
    #     puts "Pending Orders"
    #     pending_order_hash
    #     puts "Complete Orders"
    #     complete_order_hash
    # end

################################## Shopping Menu ############################################
    
    def shopping_menu
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
                    new_order = ProductOrder.find_or_create_by(order_id: self.order.id, product_id: get_inventory(command[6..-1]).pop)
                    puts "You placed an order for #{new_order.product.name}"
                else
                    puts "Sorry, we're out of stock or you entered a non-existent product."
                end
            when "remove"
                hash = {}
                self.order.product_orders.map {|productorder| hash[productorder.id] = productorder.product.name}
                pp hash
                puts "Please enter the product you'd like to remove by id"
                product_order_id = gets.chomp
                remove_item(product_order_id, hash)
                puts "That product has been removed from your cart."
            when "checkout"
                total = 0
                self.order.product_orders.sum {|productorder| total += productorder.product.cost}
                total
                puts "Your current order total is $#{total}. Would you like to proceed with the checkout Y/N?"
                decision = gets.chomp
                if decision == "Y" || decision == "y"
                    self.order.update(status: "complete")
                    puts "Your order is now complete with a total of $#{total}."
                    command = 'back'
                elsif decision == "N" || decision == "n"
                    puts "Okay, check out later then."
                end

            end
        end
    end

    def get_inventory(name)
        arr1 = ProductOrder.all.map {|productorder| productorder.product_id }
        arr2 = Product.all.select {|product| product.name.downcase.rstrip == name.downcase.rstrip}
        arr2 = arr2.map {|product| product.id}
        arr2 - arr1
    end

    def return_item
        hash = {}
        self.order.product_orders.map {|productorder| hash[productorder.id] = productorder.product.name}
        pp hash
        puts "Please enter the product you'd like to remove by id"
        product_order_id = gets.chomp
        if product_order_id == 'back' 
            return
        end
        self.remove_item(product_order_id, hash)
    end
end
