require_relative '../config/environment'

def welcome
    puts "Welcome to our Shopping Database."
end

def user_name
    puts "What is your name?"
    user = gets.chomp
    if user.empty?
        user_name
    else
        return user
    end

end


def get_inventory(name)
    arr1 = ProductOrder.all.map {|productorder| productorder.product_id }
    arr2 = Product.all.select {|product| product.name.downcase == name.downcase}
    arr2 = arr2.map {|product| product.id}
    arr2 - arr1
end
