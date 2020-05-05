class Order < ActiveRecord::Base
    belongs_to :client
    has_many :product_orders
    has_many :products, through: :product_orders
    has_many :product_types, through: :products



   

end

