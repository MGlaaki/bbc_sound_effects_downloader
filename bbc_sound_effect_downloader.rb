require 'open-uri'
require 'csv'
require 'net/http'

LOCATION,DESCRIPTION,SECS,CATEGORY,CDNUMBER,CDNAME,TRACKNUM = 0,1,2,3,4,5,6
SOURCE_FILE = open "http://bbcsfx.acropolis.org.uk/assets/BBCSoundEffects.csv"

class String
  def only_alphanum
    gsub(/[^0-9a-z]/i, '_')
  end
end

def filepath(location)
  #example : bbcsfx.acropolis.org.uk/assets/07076051.wav
  "http://bbcsfx.acropolis.org.uk/assets/#{location}"
end

def filename(row)
  "#{row[CDNAME].only_alphanum}_#{row[TRACKNUM].only_alphanum}_#{row[DESCRIPTION].only_alphanum}.wav"
end

csv = CSV.new SOURCE_FILE
size = csv.readlines.size - 1

i = 0
CSV.foreach(SOURCE_FILE) do |row|
  if i > 0 #ignore csv titles
    puts ("#{i}/#{size}")
    url = filepath(row[LOCATION])
    IO.copy_stream(open(url), filename(row)) unless File.exist?(filename(row))
    puts "#{filename(row)} OK"
  end
  i+=1
end
