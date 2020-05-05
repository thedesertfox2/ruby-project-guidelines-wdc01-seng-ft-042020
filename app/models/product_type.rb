class ProductType < ActiveRecord::Base

    has_many :products
    has_many :product_orders, through: :products
    has_many :orders, through: :product_orders
    has_many :clients, through: :orders
    

end