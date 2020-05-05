class Product < ActiveRecord::Base
    has_many :product_orders
    has_many :orders, through: :product_orders
    has_many :clients, through: :orders
    belongs_to :product_type


end