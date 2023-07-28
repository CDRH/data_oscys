# script for Laura to quickly generate some relationships (all to all)
# change the ids below to whatever you need and save!
# in terminal, navigate to directory (Desktop/repos/data_oscys/scripts), type ruby relationship_generation.rb, hit enter
# this will generate two lists, you need to put them back together in the csv as columns A and C of the rdf csv

ids = [
  "per.007102",  
  "per.007101",  
  "per.007100",
  "per.007098",
  "per.007092",
  "per.007099",
  "per.007093",  
  "per.007105",  
  "per.007094",
  "per.007096",
  "per.007095",
  "per.007097"













]

# Don't change anything below this line!

relationship_col1 = []
relationship_col2 = []

def is_valid?(id)
  return id.match(/per\.[0-9]{6}$/)
end

ids.each do |id_1|
  if is_valid?(id_1)
    ids.each do |id_2|
      if is_valid?(id_2) && id_1 != id_2
        relationship_col1 << id_1
        relationship_col2 << id_2
      end
    end
  else
    puts ">>>>INVALID ID: #{id_1} <<<<<"
  end
end

puts "Paste the following into Column A: "
puts relationship_col1.join("\n")
puts "Paste the following into Column C: "
puts relationship_col2.join("\n")