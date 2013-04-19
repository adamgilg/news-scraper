desc "Fetch latest stories"
task fetch_stories: :environment do
  require 'rubygems'
  require 'nokogiri'
  require 'open-uri'

  url = 'http://www.cnn.com/'
  doc = Nokogiri::HTML(open(url))
  news = doc.at('h4:contains("LATEST")').next_element.next_element
  links = news.css('a').map { |n| n.attributes['href'].value }.uniq
  # p links

  5.times do |i|
    if links[i].match(/^(http)/)
      url = links[i]
    else
      url = "http://www.cnn.com/#{links[i]}"
    end
    doc = Nokogiri::HTML(open(url))
    if Story.all.length == 5
      story = Story.find_by_order(i)
      if doc.css('h1').text.size > 255
        story.update_attribute(:headline, url)
        story.update_attribute(:summary, "video")
      else
        story.update_attribute(:headline, doc.css('h1').text)
        story.update_attribute(:summary, doc.css('p').first.text)
      end
      story.update_attribute(:url, url)
    else
      Story.create(headline: doc.css('h1').text,
            url: url, summary: doc.css('p').first.text,
            order: i)
    end
  end
end