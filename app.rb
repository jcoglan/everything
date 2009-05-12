require 'rubygems'
require 'sinatra'
require 'hpricot'
require 'open-uri'

RANGE = (10..30)
LANG = 'en'

get '/*' do
  @lang = params[:splat].first
  @lang = LANG if @lang == ''
  @articles = []
  n = RANGE.first + rand(RANGE.last - RANGE.first)
  threads = (1..n).map do |n|
    Thread.new do
      doc = Hpricot(open "http://#{ @lang }.wikipedia.org/wiki/Special:Random")
      title = (doc / '#firstHeading')
      url = (doc / '#p-cactions a').first
      @articles << [url.attributes['href'], title.inner_html] if url and title
    end
  end
  threads.each { |t| t.join }
  erb :index
end

