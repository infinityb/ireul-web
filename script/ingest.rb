def ingest_dir(song_glob_pattern, image_glob_pattern)
  processed_count = 0

  # File::FNM_CASEFOLD = case-insensitive option
  Dir.glob(song_glob_pattern, File::FNM_CASEFOLD).select do |song_path|
    begin
      image_path = nil
      Dir.chdir(File.dirname(song_path)) do |_d|
        image_path = Dir.glob(image_glob_pattern, File::FNM_CASEFOLD).first
      end

      puts "Ingesting song: #{song_path}, image: #{image_path}"
      ingest_song(song_path, image_path)
      processed_count += 1
    rescue StandardError => e
      puts e.inspect
      next
    end
  end

  puts "#{processed_count} songs processed."
end

def ingest_song(song_path, image_path)
  controller = SongsController.new

  File.open(song_path) do |song_file|
    image_file = File.open(image_path) if image_path
    controller.params = {
      song: { file: song_file },
      background_image: { image: image_file }
    }
    controller.create_song
    image_file.close if image_file
  end
end

root_path = ARGV[0]
song_glob_pattern = ARGV[1] || '*.ogg'
image_glob_pattern = ARGV[2] || '*.{gif,png,jpg,jpeg,bmp}'

if ARGV[0].nil?
  puts "Usage: rails runner ingest.rb <root_path> [song_glob_pattern=#{song_glob_pattern}] " +
       "[in_song_directory_image_glob_pattern=#{image_glob_pattern}]"
  puts 'rails runner <root_dir> "*/*/*.ogg" "*.{gif,png,jpg,jpeg,bmp}" for artist/album/*.ogg'
  exit
end

Dir.chdir(root_path)
ingest_dir(song_glob_pattern, image_glob_pattern)
