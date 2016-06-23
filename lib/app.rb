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

def products
  $products_hash["items"].each do |item|
    total_sales = item["purchases"].map { |purchase| purchase["price"] }.reduce(:+)
    average_cost = total_sales / item["purchases"].count
    total_purchases = item["purchases"].count
    store_to_file "- #{item["title"]} "
    store_to_file "\tretail price - $#{item["full-price"].to_f}"
    store_to_file "\tpurchases  - #{total_purchases}"
    store_to_file "\ttotal sales - $#{total_sales}"
    store_to_file "\taverage cost - $#{average_cost}"
    store_to_file "\taverage discount - $#{(item["full-price"].to_f - average_cost)}\n\n"
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

def brands
  brands = ($products_hash['items'].map { |toy| toy['brand'] }).uniq
  brands.each do |brand|
    products = $products_hash["items"].select { |item| item["brand"] == brand }

    stock = 0.0
    total_price = 0.0
    sales = 0.0

    products.each do |product|
      stock = stock + product["stock"]
      sales = sales + product["purchases"].length
      product["purchases"].each do |ind|
        total_price = total_price + ind["price"].to_f
      end
    end
    store_to_file "Brand - #{brand}"
    store_to_file "\ttotal products in stock - #{stock}"
    store_to_file "\taverage price - $#{sprintf "%.2f", total_price / sales}"
    store_to_file "\ttotal in sales - $#{sprintf "%.2f", total_price}\n\n"

  end
end

def create_report
  # Print today's date
  store_to_file date

  # Print "Sales Report" in ascii art
  store_to_file ascii("sales")

  # Print "Products" in ascii art
  store_to_file ascii("products")
  products

  # Print "Brands" in ascii art
  ascii("brands")
  brands
end


def start
  setup
  create_report
end

start
