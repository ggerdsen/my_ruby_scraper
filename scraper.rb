require 'open-uri'
require 'nokogiri'
require 'pry'

document = open('https://denver.craigslist.org/search/sof?query=ruby')
content = document.read
parsed_content = Nokogiri::HTML(content)
parsed_content.css('.content')
parsed_content.css('.content').css('.rows').css('.hdrlnk')
parsed_content.css('.content').css('.rows').css('.hdrlnk').first.inner_text
parsed_content.css('.content').css('.rows').first.inner_text
binding.pry
