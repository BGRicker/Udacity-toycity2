def setup
  report_file = $stderr
  require 'json'
  path = File.join(File.dirname(__FILE__), '../data/products.json')
  file = File.read(path)
  $products_hash = JSON.parse(file)
  $report_file = File.new("report.txt", "w+")
end

def date
  "Report Run At: #{Time.now.strftime("%m/%d/%Y %H:%M:%S %p")}"
end

def ascii(options={})
  if options[:products]
    puts "\n                     _            _       "
    puts "                    | |          | |      "
    puts " _ __  _ __ ___   __| |_   _  ___| |_ ___ "
    puts "| '_ \\| '__/ _ \\ / _` | | | |/ __| __/ __|"
    puts "| |_) | | | (_) | (_| | |_| | (__| |_\\__ \\"
    puts "| .__/|_|  \\___/ \\__,_|\\__,_|\\___|\\__|___/"
    puts "| |                                       "
    puts "|_|                                      \n\n "
  elsif options[:brand]
    puts "\n _                         _     "
    puts "| |                       | |    "
    puts "| |__  _ __ __ _ _ __   __| |___ "
    puts "| '_ \\| '__/ _` | '_ \\ / _` / __|"
    puts "| |_) | | | (_| | | | | (_| \\__ \\"
    puts "|_.__/|_|  \\__,_|_| |_|\\__,_|___/\n\n"
  elsif options[:sales]
    puts "\n           _                                       _    "
    puts "          | |                                     | |   "
    puts " ___  __ _| | ___  ___   _ __ ___ _ __   ___  _ __| |_  "
    puts "/ __|/ _` | |/ _ \\/ __| | '__/ _ \\ '_ \\ / _ \\| '__| __| "
    puts "\\__ \\ (_| | |  __/\\__ \\ | | |  __/ |_) | (_) | |  | |_  "
    puts "|___/\\__,_|_|\\___||___/ |_|  \\___| .__/ \\___/|_|   \\__| "
    puts "                                 | |                   "
    puts "                                 |_|\n\n"
  end
end


def products
  $products_hash["items"].each do |item|
    total_sales = item["purchases"].map { |purchase| purchase["price"] }.reduce(:+)
    average_cost = total_sales / item["purchases"].count
    total_purchases = item["purchases"].count
    puts "- #{item["title"]} "
    puts "\tretail price - $#{item["full-price"].to_f}"
    puts "\tpurchases  - #{total_purchases}"
    puts "\ttotal sales - $#{total_sales}"
    puts "\taverage cost - $#{average_cost}"
    puts "\taverage discount - $#{(item["full-price"].to_f - average_cost)}\n\n"
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
    puts "Brand - #{brand}"
    puts "\ttotal products in stock - #{stock}"
    puts "\taverage price - $#{sprintf "%.2f", total_price / sales}"
    puts "\ttotal in sales - $#{sprintf "%.2f", total_price}\n\n"

  end
end

def create_report
  # Print today's date
  print date

  # Print "Sales Report" in ascii art
  ascii(sales: true)

  # Print "Products" in ascii art
  ascii(products: true)
  products

  # Print "Brands" in ascii art
  ascii(brand: true)
  brands
end


def start
  setup
  create_report
end

start
