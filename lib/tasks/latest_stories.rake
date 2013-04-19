desc "Fetch latest stories"
task fetch_stories: :environment do
  require 'rubygems'
  require 'nokogiri'
  require 'open-uri'

  url = 'http://www.cnn.com/'
  doc = Nokogiri::HTML(open(url))
  news = doc.at('h4:contains("LATEST")').next_element.next_element
  links = news.css('a').map { |n| n.attributes['href'].value }
  # p links

  5.times do |i|
    url = "http://www.cnn.com#{links[i]}"
    doc = Nokogiri::HTML(open(url))
    if Story.all.length == 5
      story = Story.find_by_order(i)
      if story.headline.size > 255
        story.update_attribute(:headline, url)
      else
        story.update_attribute(:headline, doc.css('h1').text)
      end
      story.update_attribute(:url, url)
      story.update_attribute(:summary, doc.css('p').first.text)
    else
      Story.create(headline: doc.css('h1').text,
            url: url, summary: doc.css('p').first.text,
            order: i)
    end
  end
end