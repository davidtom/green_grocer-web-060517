require "pry"

def consolidate_cart(cart)
  consolidated_cart = {}
  cart.each { |item|
    #store item name, which is the key of the hash stored in array
    item_name = item.keys[0]
    #If there is not already a key for the item_name in consolidated_cart,
    # create it and set value equal to item info (another hash); also create
    # count key/value pair in hash
    if !consolidated_cart.keys.include?(item_name)
      consolidated_cart[item_name] = item[item_name]
      consolidated_cart[item_name][:count] = 1
    # If key does already exist, increment count
    elsif consolidated_cart.keys.include?(item_name)
      consolidated_cart[item_name][:count] += 1
    end
  }
  consolidated_cart
end

def apply_coupons(cart, coupons = [])
  # Make sure coupons are an array of hashes; if not, adde them to an array
  coupons = [coupons] if coupons.class == Hash

  # Iterate through each coupon in the coupons array
  coupons.each { |coupon|
    if cart.keys.include?(coupon[:item])
      coupon_item_name = "#{coupon[:item]} W/COUPON"
      if cart[coupon[:item]][:count] >= coupon[:num]
        if !cart.keys.include?(coupon_item_name)
          cart[coupon_item_name] = {
            price: coupon[:cost],
            clearance: cart[coupon[:item]][:clearance],
            count: 1
          }
        elsif cart.keys.include?(coupon_item_name)
          cart[coupon_item_name][:count] += 1
        end
        cart[coupon[:item]][:count] -= coupon[:num]
      end
    end
  }
  cart
end

def apply_clearance(cart)
  cart.each { |item, details|
    if cart[item][:clearance]
      cart[item][:price] = (cart[item][:price] * 0.8).round(2)
    end
  }
end

def checkout(cart, coupons)
  consolidated_cart = consolidate_cart(cart)
  coupon_cart = apply_coupons(consolidated_cart, coupons)
  clearance_cart = apply_clearance(coupon_cart)
  # binding.pry

  cart_total = 0

  clearance_cart.each { |item, details|
    cart_total += details[:price] * details[:count]
    # binding.pry
  }

  if cart_total > 100.0
    cart_total * 0.9
  else cart_total
  end

end

def cart
  [
  {"BEER" => {:price => 13.00, :clearance => false}},
  {"BEER" => {:price => 13.00, :clearance => false}},
  {"BEER" => {:price => 13.00, :clearance => false}}
  ]
end

def coupon
  [{:item => "BEER", :num => 2, :cost => 20.00},
    {:item => "BEER", :num => 2, :cost => 20.00}]
end

# puts apply_coupons(consolidate_cart(cart), coupon)
