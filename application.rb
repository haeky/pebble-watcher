require 'nokogiri'
require 'watir'
require 'twitter'
require 'sinatra'
require 'open-uri'

$available = false

$client = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
  config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
  config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
  config.access_token_secret = ENV['TWITTER_ACCESS_SECRET']
end

Thread.new do
  while true do
    browser = Watir::Browser.new :phantomjs
    browser.goto('https://getpebble.com/checkout')

    document = Nokogiri::HTML.parse(browser.html)
    div = document.css('div.steel_black')

    $available = div.css('div.discontinued-message').first.attr('class').include?('ng-hide')

    if $available
      $client.update('@Goluom, Pebble Steel is now out <3')
      Thread.stop
    end

    sleep 120
  end
end

get '/' do
  if $available
    'Pebble Steel is now out <3'
  else
    'Pebble Steel is not out yet :('
  end
end
