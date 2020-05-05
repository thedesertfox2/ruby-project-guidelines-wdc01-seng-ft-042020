class Manufacturer < ActiveRecord::Base
    has_many :inventory
    has_many :products, through: :inventory

end