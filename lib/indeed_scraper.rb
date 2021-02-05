require_relative './scraper.rb'
require 'nokogiri'
require 'httparty'
require 'pry'

class IndeedScraper < Scraper
  attr_accessor :url

  def initialize(url)
    @url = url
    @result = ['Title,Company,Location,Summary,Date_Posted,Easily_Apply?,URL']
  end

  def scrape
    parsed_page = parsing_page(@url)  # calls private method `parsing_page` within the Scraper parent class
    total_pages = total_pages_finder(parsed_page, 'div.searchCount-a11y-contrast-color')
    pages_append_urls = page_ending_urls(total_pages)
    scrape_per_page(pages_append_urls)
    sorted_arr = sort_by_dates(@result)
    write('indeed_jobs.csv', sorted_arr, 'jobs matching your search criteria')
    
  end
  
  def total_pages_finder(parsed_page, page_css_property)
    parsed_page.css(page_css_property).text[48..50].to_i
  end
  
  def page_ending_urls(total_pages)
    (0..total_pages).to_a.select { |i| (i % 10).zero? }
  end
  
  def scrape_per_page(urls_arr)
    urls_arr.each do |page|
      each_page_url = @url + "&start=#{page}"
      parsed_page = parsing_page(each_page_url)
      job_listings = parsed_page.css('div.jobsearch-SerpJobCard')
      add_jobs(job_listings)
      puts "#{@result.length - 1} jobs meeting your search criteria have been scraped from indeed.com..."
    end
  end
  
  def sort_by_dates(arr)
    [arr[0]] + arr[1..-1].sort_by { |str| str.split(',')[-1][0, 2].to_i }
  end
  
  def add_jobs(job_listings)
    job_listings.each do |listing|
      title = listing.css('a.jobtitle').text.gsub("\n", '').gsub(',', ' ')
      company = listing.css('span.company').text.gsub("\n", '').gsub(',', ' ')
      location = 'remote' # css is 'span.location' if needed
      summary = listing.css('div.summary').text.gsub("\n", '').gsub(',', ' ')
      key_url = listing.css('a')[0].attributes['href'].value[7..-1]
      url = append_link_type(key_url)
      day_posted = listing.css('span.date').text.gsub("\n", '')
      easy_apply = !(listing.css('td.indeedApply').text).empty?
      @result << "#{title},#{company},#{location},#{summary},#{day_posted},#{easy_apply},#{url}"
    end
  end
  
  # appends link parameters dependant upon the path
  def append_link_type(key_url)
    if key_url.start_with?('y/')
      'https://www.indeed.com/compan' + key_url
    elsif key_url.start_with?('?jk=')
      'https://www.indeed.com/viewjob' + key_url
    elsif key_url.start_with?('/clk?mo')
      'https://www.indeed.com/pagead' + key_url
    else
      'unknown parameter, adjust in `append_link_type` method in indeed_scraper class...'
    end
  end
end