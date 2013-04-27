require 'active_support'

def sum_hash(hash)
  hash.values.inject(:+)
end

def format_money(amount)
  "%.2f $" % (amount)
end

def format_as_line_items(hash)
  key_max_length = hash.keys.map   { |key| key.length }.max
  val_max_length = hash.values.map { |val| format_money(val).length }.max
  page       = []

  hash.each do |key, value|
    key_spacer = key_max_length - key.length
    val_spacer = val_max_length - format_money(value).length
    line   = "#{key.to_s} " +
             "#{'.' * key_spacer}#{' ' * val_spacer} " +
             "#{format_money value}"
    @line_length ||= line.length
    page   << line
  end

  page.each { |line| puts line }
  puts "_" * @line_length

  total  = format_money(sum_hash hash)
  spacer = @line_length - total.length - 7 # seven for the word total and 2 spaces.
  puts "total #{'.' * spacer} #{total}"
end

budget = { funds:        1000.00,
           rent:         -300.00,
           utilities:     -35.00,
           credit_debt:  -100.00 }

number_of_fridays = 5
weekly            = { fun_money: 20.00, groceries: 80.00 }
weekly_expenses   = -(sum_hash weekly)

number_of_fridays.times do |count|
  budget["week_#{count}".to_sym] = weekly_expenses
end

format_as_line_items budget
