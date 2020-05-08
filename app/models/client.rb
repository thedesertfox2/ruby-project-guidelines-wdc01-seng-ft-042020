class Client < ActiveRecord::Base
    has_many :orders
    has_many :product_orders, through: :orders
    has_many :products, through: :product_orders
    has_many :product_types, through: :products

    def generate_pending_orders
        order_arr = self.orders.where(status: "pending")
        pending_order_hash = {}
        order_arr.each do |order| 
            pending_order_hash[order.id] = order.products.map {|product| product.name + ", cost: $" + product.cost.to_s}
        end
        pending_order_hash
    end
    
end