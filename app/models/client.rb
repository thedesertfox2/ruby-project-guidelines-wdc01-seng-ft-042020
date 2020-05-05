class Client < ActiveRecord::Base
    has_many :client_orders
end