require 'net/https'
require 'rexml/document'

URL = 'http://www.cbr.ru/scripts/XML_daily.asp'.freeze

def dollar_exchange(rub, usd, rate)
  dif = (usd - rub / rate)

  return 0 if dif.abs <= 0.01

  (dif / 2).round(2)
end

begin
  response = Net::HTTP.get_response(URI.parse(URL))
  doc = REXML::Document.new(response.body)
  rate = doc.root.elements["Valute [@ID='R01235']/Value"].text.sub(',', '.').to_f
rescue SocketError
  puts 'Нет подключения!'
  puts 'Введите курс доллара'
  rate = gets.to_f
end

puts "Курс ЦБ #{rate} рублей за доллар США"
puts
puts 'Сколько у вас рублей?'
rub = gets.to_f
puts 'Сколько у вас долларов?'
usd = gets.to_f

dif = dollar_exchange(rub, usd, rate)

if dif == 0
  puts 'Ваш портфель сбалансирован!'
elsif dif < 0
  puts "Вам надо купить #{dif.abs}$"
else
  puts "Вам надо продать #{dif}$"
end
