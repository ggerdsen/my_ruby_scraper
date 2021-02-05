require 'open-uri'
require 'nokogiri'
require 'pry'

document = open('https://denver.craigslist.org/search/sof?query=ruby')
content = document.read
binding.pry
parsed_content = nokogiri::HTML(content)
