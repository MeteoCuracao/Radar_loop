# Written during Apps4Curaçao
# March 3 - 8, 2013
# Bert Spaan, Waag Society
# bert@waag.org
# bert.spaan@gmail.com

#!/usr/local/Cellar/ruby/1.9.3-p327/bin/ruby 

require 'json'

# ImageMagick commands:
#  composite -compose subtract background.png CUR130305134500.CAPLZ58.gif output.png
#  convert output.png -negate output.png 
#  convert output.png -transparent white output2.png
#  convert output2.png -crop 719x720+0+0  output3.png

tmp_dir = "tmp/"
dst_dir = "output/"

images = []
images_t = []

File.open('loop.txt').each do |src|
  src.gsub!("\\", "/").strip!
 
  puts "#{src}"
  
  tmp = tmp_dir + File.basename(src, ".gif") + ".png"
  dst = dst_dir + File.basename(src, ".gif") + ".png"
  
  #system "composite -compose subtract background.png #{src} #{tmp}" 
  #system "convert #{src} background.png -compose Change-mask -composite #{tmp}"
  #system "convert #{tmp} -negate #{tmp}"
  
  system "composite #{src} background.png -compose Difference #{tmp}"
  system "convert #{tmp} -negate #{tmp}"
  
  system "convert #{tmp} -transparent white #{tmp}"
  system "convert #{tmp} -crop 719x720+0+0 #{tmp}"

  system "convert #{tmp} -channel rgba -matte -fill \"rgba(0,0,0,0.3)\" -opaque \"rgba(138,138,56,1)\" #{tmp}"
  system "convert #{tmp} -channel rgba -matte -fill \"rgba(0,0,0,0.3)\" -opaque \"rgba(85,100,160,1)\" #{tmp}"
  
  images_t << tmp
  images << dst
end

system "convert %s +append %s" % [images_t.join(" "), dst_dir + "radar.png"]

File.open(dst_dir + "images.js","w") do |f|
  f.write("images = " + images.to_json)
end