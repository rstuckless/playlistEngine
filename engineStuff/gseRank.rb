require 'net/http'
require 'json'
require 'cgi'
require 'watir-webdriver'
require 'pry'
require './engineStuff/ytapi.rb'

#ID=1111111111111111:LD=en:TM=1441034920:LM=1446502284:L=1Xw:GM=1:S=XVC31mIaglVj_LLw

class GoogleSearchHelper

	def initialize()
		# profile = Selenium::WebDriver::Firefox::Profile.new
		# profile['browser.privatebrowsing.dont_prompt_on_enter'] = true
		# profile['browser.privatebrowsing.autostart'] = true
		# @b = Watir::Browser.new :firefox, :profile => profile
		@b = Watir::Browser.new :phantomjs
		# puts 'trying to refresh'
		@b.refresh
		# puts 'trying to go to google'
		@b.goto 'google.com'

		# @yt = YoutubeApi.new
		@b.cookies.add('PREF','ID=1111111111111111:LD=en:TM=1441034920:LM=1446502284:L=1Xw:GM=1:S=XVC31mIaglVj_LLw')
	end	

	def firstRanked(queryterm)
		# years = {'2015' => [] ,'2014'=>[],'2013'=>[],'2012'=>[],'2011'=>[], '2010'=>}
		query = CGI.escape(queryterm)
		graphUrl = 'http://www.google.com/trends/fetchComponent?q='+ query + '&cid=TIMESERIES_GRAPH_0&export=3'
		# uri = URI.parse(graphUrl)
		# puts graphUrl
		# req1 = Net::HTTP::Get.new(uri.to_s)
		# cookie1 = CGI::Cookie.new('PREF','ID=1111111111111111:LD=en:TM=1441034920:LM=1446502284:L=1Xw:GM=1:S=XVC31mIaglVj_LLw')
		# req1['Cookie'] = cookie1.to_s
		# res1 = Net::HTTP::start(uri.host, uri.port){|http| http.request(req1)}

		@b.goto graphUrl

		if @b.html.include?'rows'
			# puts 'Actual data for: ' + queryterm
			coordinates = @b.html.split('{"c')
			highest = 0
			releaseYear = ''
			yCoordinate = ''
			coordinates.each do |plot| 
				# binding.pry
				data = plot.split('"')
				yCoordinate = data[12].to_i
				# if yCoordinate != 0
				# 	puts yCoordinate
				# end
				# queryTotal = dat[12].to_i
				date = data[6]
				year = date.split(' ')[1]
				# print yCoordinate
				# puts yCoordinate
				if yCoordinate > (highest*1.75)
					# videoUrl = @yt.getvideo(query)
					return year, date
					# releaseYear = date
					# break
				elsif yCoordinate > highest
					highest = yCoordinate
				end	
			end
		else
		end	
		return '','',''
	end
end

# g = GoogleSearchHelper.new
# g.firstRanked('The Presets My People')