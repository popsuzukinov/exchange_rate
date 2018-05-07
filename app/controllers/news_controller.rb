require 'feedjira'
require 'date'

class NewsController < ApplicationController
  def index
    sites = [
    "http://gihyo.jp/feed/rss1"

    ]
    @list = []
    sites.each do |site|
      rss = Feedjira::Feed.fetch_and_parse site
      rss.entries.each do |item|
      @list += [:title => item.title,
              :url => item.url,
              :summary => item.summary,
              :published => item.published.to_time.strftime("%Y-%m-%d %H:%M:%S")]
      end
   end

   @list
  end

  def index2
    sites = [
    "http://www.zou3.net/php/rss/nikkei2rss.php?head=keizai"

    ]
    @list = []
    sites.each do |site|
      rss = Feedjira::Feed.fetch_and_parse site
      rss.entries.each do |item|
      @list += [:title => item.title,
              :url => item.url,
              :summary => item.summary,
              :published => item.published.to_time.strftime("%Y-%m-%d %H:%M:%S")]
      end
   end

   @list
  end
end
