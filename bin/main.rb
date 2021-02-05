require_relative '../lib/indeed_scraper.rb'

# menu at run
puts '*********************************************************************'
puts ''
puts 'Entry Level Job Scraper'
puts 'By: Garrett Gerdsen'
puts ''
puts '*********************************************************************'
puts ''
puts 'Which website do you want to scrape? (indeed)'

# user input for job search engine here
input = ''
loop do
  input = gets.chomp
  break if ['udacity', 'indeed', 'remote.io'].include?(input)
  puts 'Error, please enter a valid selection (indeed only at this time...)'
end

puts 'Enter a job title or other search string'

search = ""
search = gets.chomp


# calls the IndeedScraper class
if input == "indeed"
  url = "https://www.indeed.com/jobs?q=#{search}&l=Remote&explvl=entry_level&sort=date"
  website = IndeedScraper.new(url)
end

# initiates scraping within the IndeedScraper class which inherits from the main Scraper class
website.scrape