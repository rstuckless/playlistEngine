
require 'csv'
require 'pry'
require './engineStuff/gseRank.rb'
require './engineStuff/ytapi.rb'
require './engineStuff/lastfm.rb'
# g = GoogleSearchHelper.new
@yt = YoutubeApi.new
lastFM = LastFMHelper.new
newTracks = []
playlists = {}

# chartJson = lastFM.getChart

# tracks = lastFM.getChart

# binding.pry

# CSV.open("fulltracklist.csv", "w") do |csv|
# tracks.each do |track|
# 	artistName = track['artist']['#text']
# 	trackName = track['name']
# 	listens = track['playcount']
# 	trackInfo = lastFM.getTrackInfo(artistName, trackName)	
# 	if trackInfo["track"] != nil && trackInfo["track"]["userplaycount"] != nil
# 		listens = trackInfo["track"]["userplaycount"]
# 	end

# 	csv << [artistName, trackName, listens,0]
# end	
# end

i = 0
fullCSV =[]
CSV.foreach(File.path("fulltracklist.csv")) do |row|
	if row[3]=='0'
		artistName = row[0]
		trackName = row[1]
		plays = row[2]
		# googleInfo = g.firstRanked(artistName + ' ' + trackName)
		youtubeData = @yt.getFirstVideoYear(artistName + ' ' + trackName)
		date = youtubeData[1]
		year = youtubeData[0]
		# videoUrl = youtubeData[2]
		# year = googleInfo[0]
		# date =  @yt.getFirstVideoYear(artistName + ' ' + trackName)[1]
		videoUrl = @yt.getvideo(artistName + ' ' + trackName)
		if year != '' 
			puts 'adding ' + artistName + ':'+ trackName + ' to the ' + year.to_s + ' playlist '
			playlistName = year.to_s+'playlist.csv'
			CSV.open(playlistName, 'a') do |csv|
				csv << [artistName, trackName, year, date, plays, videoUrl]
			end
		else
			CSV.open('noyearSongs.csv','a') do |csv|
				csv << [artistName, trackName, 0, 0, plays, videoUrl]
			end
		end
		# i++
		row[3] = 1
	end
	fullCSV.push([artistName, trackName, plays, row[3]])
	print '.'
end	

# binding.pry





# tracks.each do |track|
# 	artistName = track['artist']['#text']
# 	trackName = track['name']
# 	# puts 'Trying ' + artistName + ':' + trackName


# 	googleInfo = g.firstRanked(artistName + ' ' + trackName)
# 	year = googleInfo[0]
# 	date = googleInfo[1]
# # 	# year = 2015
# # 	# date = 'december 2015'
# 	videoUrl = @yt.getvideo(artistName + ' ' + trackName)
# 	print '.'
# 	if year != '' 
# # 		if playlists[year] == nil
# # 			playlists[year] = []
# # 		end
# # 		i = i+1
# 		puts 'adding ' + artistName + ':'+ trackName + ' to the ' + year.to_s + ' playlist '
# 		playlists[year].push({'artist'=>artistName,'trackName'=>trackName,'year'=>year, 'date'=>date, 'videoUrl'=>videoUrl})
# 	end	
# 	if i > 25
# 		break
# 	end	
# end

# # binding.pry

# playlists.each do |year, playlist| 
# 	fname = 'playlist'+year.to_s+'.csv'
# 	CSV.open(fname,"w") do |csv|
# 		csv << playlist.first.keys
# 		playlist.each do |song|
# 			csv << song.values
# 		end
# 	end	
# 		# CSV.open(fname,"wb") do |csv| {
# 		# playlist.each do |song|
# 		# 	# csv << song['videoUrl']
# 		# 	 puts song['videoUrl']
# 		# end
# 		# csv<<'hi'
# 		# }
# end


# http://ws.audioscrobbler.com/2.0/?method=track.getInfo&api_key=de76bb331cc84f7fe2c77183c88b2f30&track=38128b63-0557-4d63-82e8-c1f7474acdd1&format=json
# http://ws.audioscrobbler.com/2.0/?method=track.getInfo&api_key=b25b959554ed76058ac220b7b2e0a026&track=Jazzhole&artist=Free%20the%20Robots&format=json
