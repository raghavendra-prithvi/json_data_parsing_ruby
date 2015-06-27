

############Code Sample #########
require 'rubygems'
require 'json'
require 'net/http'
file = File.open("input_talksinterview.txt", "rb")
File.open("output.txt", "w")
if FileTest::directory?("video")
else
  Dir::mkdir("video")
end
contents = file.read
json_data = JSON.parse(contents)
json_data.each do |jd|
  output = Hash.new
  background_image = jd["backgroundImage"]  
	y_url = jd["ingredients"][1]["youtube_url"]
  link_url = jd["ingredients"][0]["link_url"]
	title = link_url.split('/').last	
	yv_url = y_url.split('/').last.split('?').first
	youtube_vedio_url = "http://s3.amazonaws.com/KA-youtube-converted/#{yv_url}.mp4/#{yv_url}.mp4"
	video_url = "http://babycarrot.us/video/talks-and-interviews/-talks-and-interviews-v-#{title}.mp4"
	rename_url = "-talks-and-interviews-v-#{title}.mp4"
	title_data = title.split("-").map(&:capitalize).join(" ")
	title_value = title_data +" : "+title_data
	output["background_image"] = background_image
	output["youtube_vedio_url"] = youtube_vedio_url
	output["video_url"] = video_url
	output["Title"] = title_value
	output["youtube_url"] = link_url
	File.open("output.txt", "a") do |f|
		f << output.to_json
	end	
	  Net::HTTP.start("s3.amazonaws.com") do |http|
      resp = http.get("/KA-youtube-converted/#{yv_url}.mp4/#{yv_url}.mp4")
      open("video/"+rename_url, "w") do |file|
        file.write(resp.body)
      end
    end    
end

puts "All files downloaded!!"
