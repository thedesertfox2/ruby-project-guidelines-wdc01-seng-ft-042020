class Client < ActiveRecord::Base
    has_many :orders
    has_many :apparels, through: :orders
    
end