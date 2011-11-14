class Song
  #знам, че е грозно и нередно, но трябваше да смаля дължината
  # на имената на методите за проверка, понеже се оказа,
  # че не мога да пренасям условия на няколко реда
  attr_accessor :name, :artist, :genre, :subgenre, :tags
  def initialize(songname, artist, lotsofgenres, lotsoftags)
    @name, @artist = songname.strip, artist.strip
    @genre, @subgenre = lotsofgenres.split(/\s*\,\s*/)
    @tags = lotsoftags.split(/\s*\,\s*/) if lotsoftags!=nil
    @tags = Array.new if lotsoftags==nil
    @genre.strip
    @subgenre.strip if subgenre!=nil
    @tags.each {|tag| tag.strip} if tags!=nil
  end
  def matches? cri
  #за този ред става въпрос
    if a?(cri[:artist]) and n?(cri[:name]) and t?(cri[:tags]) and f?(cri[:filter])
      then true
    else
      false
    end
  end
  def n?(name)
    if(name==nil)
      then true
      else @name==name
    end
  end
  def a?(artist)
    if(artist==nil)
      then true
    else @artist==artist
    end
  end
  def f?(filter)
    if(filter==nil)
      then true
    else filter.(self)
    end
  end
  def t?(tags)
    if(tags==nil or tags.length==0)
      then true
    else 
      tags = [tags] unless tags.kind_of? Array
      tags.all? {|tag| matches_tag? tag}
    end
  end
  def matches_tag? tag
    if tag.end_with?("!")
      then result = false 
      result = true unless @tags.include? tag[0...-1]
      result
    else @tags.include? tag
    end
  end
  def genresToTags
    @tags<<@genre.downcase
    @tags<<@subgenre.downcase if @subgenre!=nil
    @tags.uniq!
  end
end

class Collection
  def initialize(songs_as_string, artist_tags)
    @arrayofsongs = Array.new
    array = Array(songs_as_string.lines)
    array.each do |line|
      name, artist, lotsofgenres, lotsoftags = line.chomp.split(/\s*\.\s*/)
      @arrayofsongs<<Song.new(name, artist, lotsofgenres, lotsoftags)
    end
    artistsToTags(artist_tags)
  end
  def artistsToTags(artist_tags)
    @arrayofsongs.each do |song|
      song.tags.concat artist_tags[song.artist] if artist_tags.has_key? song.artist
    end
    @arrayofsongs.each do |song|
      song.genresToTags
    end
  end
  def find criteria
    @arrayofsongs.select { |song| song.matches? criteria }
  end
  def to_s
    @arrayofsongs.each {|song| puts song.to_s}
  end
end