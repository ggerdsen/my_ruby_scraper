require_relative './scraper.rb'
require 'nokogiri'
require 'httparty'
require 'pry'

class IndeedScraper < Scraper
  attr_accessor :url

  def initialize(url)
    @url = url
    @result = ['Title,Company,Location,Summary,URL, Day_posted']
  end

  def scrape
    parsed_page = parsing_page(@url)
    total_pages = total_pages_finder(parsed_page, 'div.searchCount-a11y-contrast-color')
    pages_append_urls = page_ending_urls(total_pages)
    scrape_per_page(pages_append_urls)
    
    
    binding.pry
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
      jobs_listings = parsed_page.css('div.jobsearch-SerpJobCard')
      add_jobs(jobs_listings)
      puts "#{@result.length - 1} Ruby-on-Rails jobs have been scraped from indeed.com..."
    end
  end
  
  def sort_by_dates(arr)
    [arr[0]] + arr[1..-1].sort_by { |str| str.split(',')[-1][0, 2].to_i }
  end
end