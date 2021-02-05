require_relative '../lib/indeed_scraper.rb'

puts '*********************************************************************'
puts ''
puts 'Entry Level Job Scraper'
puts 'By: Garrett Gerdsen'
puts ''
puts '*********************************************************************'
input = ''
puts 'Which website do you want to scrape? (indeed)'

# user input for job search engine here
loop do
  input = gets.chomp
  break if ['udacity', 'indeed', 'remote.io'].include?(input)

  puts 'Error, please enter a valid selection (indeed)'
end

# calls the IndeedScraper class
if input == "indeed"
  url = 'https://www.indeed.com/jobs?q=Ruby+On+Rails&l=Remote&explvl=entry_level&sort=date'
  website = IndeedScraper.new(url)
end

website.scrape