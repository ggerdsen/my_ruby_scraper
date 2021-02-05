require_relative '../lib/indeed_scraper.rb'

# menu at run
puts '*********************************************************************'
puts ''
puts 'Entry Level Remote Job Scraper'
puts 'By: Garrett Gerdsen'
puts ''
puts '*********************************************************************'
puts ''
puts 'Which website do you want to scrape? (Indeed only at this time...)'

# user input for job search engine here
input = ''
loop do
  input = gets.chomp
  break if ['indeed'].include?(input.downcase)
  puts 'Error, please enter a valid selection (Indeed only at this time...)'
end

puts 'Enter a job title or other search string'

search = ""
search = gets.chomp

# this adds a hyphen if there is whitespace between search terms
paramerized_search = search.gsub(/[\s\-]+/, '-')

# calls the IndeedScraper class
if input == "indeed"
  url = "https://www.indeed.com/jobs?q=#{paramerized_search}&l=Remote&explvl=entry_level&sort=date"
  website = IndeedScraper.new(url)
end

# initiates scraping within the IndeedScraper class which inherits from the main Scraper class
website.scrape