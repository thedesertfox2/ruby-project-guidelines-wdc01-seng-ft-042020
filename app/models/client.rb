class Client < ActiveRecord::Base
    has_many :orders
    has_many :apparels, through: :orders

    # def place_order(product_name)
        
    # end
    
end