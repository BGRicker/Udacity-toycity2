def setup
  require 'json'
  path = File.join(File.dirname(__FILE__), '../data/products.json')
  file = File.read(path)
  $products_hash = JSON.parse(file)
  $report_file = File.new("report.txt", "w+")
end

def store_to_file (output="")
    $report_file.puts output 
end

def date
  "Report Run At: #{Time.now.strftime("%m/%d/%Y %H:%M:%S %p")}\n\n"
end

#originally had ascii using products, brands, and sales as options hashes but
#didn't think that really benefitted it. Thought I was doing it just for the
#sake of using option hashes
def ascii(type)
  if type == "products"
    store_to_file "\n                     _            _       "
    store_to_file "                    | |          | |      "
    store_to_file " _ __  _ __ ___   __| |_   _  ___| |_ ___ "
    store_to_file "| '_ \\| '__/ _ \\ / _` | | | |/ __| __/ __|"
    store_to_file "| |_) | | | (_) | (_| | |_| | (__| |_\\__ \\"
    store_to_file "| .__/|_|  \\___/ \\__,_|\\__,_|\\___|\\__|___/"
    store_to_file "| |                                       "
    store_to_file "|_|                                      \n\n "
  elsif type == "brands"
    store_to_file "\n _                         _     "
    store_to_file "| |                       | |    "
    store_to_file "| |__  _ __ __ _ _ __   __| |___ "
    store_to_file "| '_ \\| '__/ _` | '_ \\ / _` / __|"
    store_to_file "| |_) | | | (_| | | | | (_| \\__ \\"
    store_to_file "|_.__/|_|  \\__,_|_| |_|\\__,_|___/\n\n"
  elsif type == "sales"
    store_to_file "\n           _                                       _    "
    store_to_file "          | |                                     | |   "
    store_to_file " ___  __ _| | ___  ___   _ __ ___ _ __   ___  _ __| |_  "
    store_to_file "/ __|/ _` | |/ _ \\/ __| | '__/ _ \\ '_ \\ / _ \\| '__| __| "
    store_to_file "\\__ \\ (_| | |  __/\\__ \\ | | |  __/ |_) | (_) | |  | |_  "
    store_to_file "|___/\\__,_|_|\\___||___/ |_|  \\___| .__/ \\___/|_|   \\__| "
    store_to_file "                                 | |                   "
    store_to_file "                                 |_|\n\n"
  end
end

def total_sales(item)
  item["purchases"].map { |purchase| purchase["price"] }.reduce(:+)
end

def average_cost(item)
  total_sales(item) / item["purchases"].count
end

def name(item)
  "- #{item["title"]}"
end

def retail_price(item)
  item["full-price"].to_f
end

def total_purchases(item)
  item["purchases"].count
end

def average_cost(item)
  total_sales(item).to_f / total_purchases(item).to_i
end

def average_discount(item)
  sprintf "%.2f", (retail_price(item).to_f - average_cost(item))
end

def products_base
  $products_hash["items"].each do |item|
    store_to_file name(item)
    store_to_file "\t\tretail price  - $#{retail_price(item)}"
    store_to_file "\t\tpurchases  - #{total_purchases(item)}"
    store_to_file "\t\ttotal sales - $#{total_sales(item)}"
    store_to_file "\t\taverage cost - $#{average_cost(item)}"
    store_to_file "\t\taverage discount - $#{average_discount(item)}\n\n"
  end
end

# For each product in the data set:
# Print the name of the toy
# Print the retail price of the toy
# Calculate and print the total number of purchases
# Calculate and print the total amount of sales
# Calculate and print the average price the toy sold for
# Calculate and print the average discount (% or $) based off the average sales price


# For each brand in the data set:
# Print the name of the brand
# Count and print the number of the brand's toys we stock
# Calculate and print the average price of the brand's toys
# Calculate and print the total sales volume of all the brand's toys combined

def brands_array
  ($products_hash['items'].map { |toy| toy['brand'] }).uniq
end

def products_array(brand)
  $products_hash["items"].select { |item| item["brand"] == brand }
end

def brand_name(brand)
  brand
end

def stock(brand)
  total_stock = 0
  brands = $products_hash["items"].select { |item| item["brand"] == brand }
  brands.each do |stock_count|
    total_stock = total_stock + stock_count["stock"].to_i
  end
  total_stock
end

def total_brand_sales(brand)
  total_sales = 0
  brands = $products_hash["items"].select { |item| item["brand"] == brand }
  brands.each do |sales|
    total_sales = total_sales + sales["purchases"].length
  end
  total_sales
end

def total_brand_price(brand)
  total_price = 0.0
  brands = $products_hash["items"].select { |item| item["brand"] == brand }
  brands.each do |sales|
    sales["purchases"].each do |ind|
      total_price = total_price + ind["price"].to_f
    end
  end
    sprintf "%.2f", total_price
end

def average_brand_price(brand)
  sprintf "%.2f", (total_brand_price(brand).to_f / total_brand_sales(brand))
end

def brands
  brands_array.each do |brand|
    store_to_file "Brand - #{brand_name(brand)}"
    store_to_file "\t\ttotal products in stock - #{stock(brand)}"
    store_to_file "\t\taverage price - $#{average_brand_price(brand)}"
    store_to_file "\t\ttotal in sales - $#{total_brand_price(brand)}"
  end
end

def create_report
  # Print today's date
  store_to_file date

  # Print "Sales Report" in ascii art
  store_to_file ascii("sales")

  # Print "Products" in ascii art
  store_to_file ascii("products")
  products_base

  # Print "Brands" in ascii art
  ascii("brands")
  brands
end


def start
  setup
  create_report
end

start
