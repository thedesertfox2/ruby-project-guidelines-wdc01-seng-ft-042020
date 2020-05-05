class Client < ActiveRecord::Base
    has_many :orders
    has_many :product_orders, through: :orders
    has_many :products, through: :product_orders
    has_many :product_types, through: :products

    # def place_order(product_name)
        
    # end
    
end