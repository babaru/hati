require 'box-api'

account = Box::Account.new('s7izrbkxzy8d2dsi9obk45crpyug51e4')
account.authorize do |auth_url|
  puts "Please visit #{ auth_url } and enter your account infomation"
  puts "Press the enter key once you have done this."
  gets
end

puts account.auth_token
