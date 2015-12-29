require 'net/http'
require 'json'
require 'cgi'
require 'pry'

class LastFMHelper
#2012
#2015 1420070400 => 1449705600
	def getChart(from=1446336000, to=1449705600)
		url = URI.parse("http://ws.audioscrobbler.com/2.0/?method=user.getWeeklyTrackChart&api_key=de76bb331cc84f7fe2c77183c88b2f30&user=TT_Discotheque&from="+from.to_s + "&to=" + to.to_s+"&format=json")
		req = Net::HTTP::Get.new(url.to_s)
		res = Net::HTTP::start(url.host, url.port){|http| http.request(req)}
		chartJson = JSON.parse(res.body)
		return chartJson['weeklytrackchart']['track']
	end
	def getTrackInfo(artist, track)
		uri = URI.parse('http://ws.audioscrobbler.com/2.0/?method=track.getInfo&api_key=b25b959554ed76058ac220b7b2e0a026&user=TT_Discotheque&track='+CGI.escape(track)+'&artist='+CGI.escape(artist)+'&format=json')
		req1 = Net::HTTP::Get.new(uri.to_s)
		res1 = Net::HTTP::start(uri.host, uri.port){|http| http.request(req1)}
		return trackJson = JSON.parse(res1.body)
	end
end

# l = LastFMHelper.new
# # binding.pry
# chart = l.getChart
# puts chart.length
