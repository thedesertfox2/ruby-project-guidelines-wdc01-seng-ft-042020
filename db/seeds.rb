Client.destroy_all
Product.destroy_all
Order.destroy_all
ProductOrder.destroy_all
ProductType.destroy_all

Client.find_or_create_by(name: "admin")
Client.find_or_create_by(name: "Paul")


# bob = Client.find_or_create_by(name: "Bob")
# alex = Client.find_or_create_by(name: "Alex")

sock = ProductType.find_or_create_by(name: "Socks")
pencil = ProductType.find_or_create_by(name: "Pencils")

# order = Order.create(status: "pending", client_id: bob.id)
# order2 = Order.create(status: "pending", client_id: alex.id)



# # product3 = 


10.times do 
    Product.create(name: "Hanes Low Cut Socks", cost: 5.50, product_type_id: sock.id)
end

10.times do 
    Product.create(name: "Dixon Ticonderoga No. 2", cost: 0.99, product_type_id: pencil.id)
end



# po1 = ProductOrder.find_or_create_by(order_id: order.id, product_id: product1.id)


# pp get_inventory("Hanes Low Cut Socks")

