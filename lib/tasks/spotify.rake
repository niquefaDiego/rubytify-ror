namespace :spotify do
  task :import do
    puts "Client ID: #{ENV["SPOTIFY_CLIENT_ID"]}"
    puts "Client Secret: #{ENV["SPOTIFY_CLIENT_SECRET"]}"
  end
end

