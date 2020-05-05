class Order < ActiveRecord::Base
    belongs_to :client
    has_many :inventories, through: :apparels
    has_many :apparels

    


end

