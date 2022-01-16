Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace 'api' do
    namespace 'v1' do
      get '/artists', to: 'artists#list'
      get '/artists/:id/albums', to: 'artists#list_albums'
      get '/albums/:id/songs', to: 'albums#list_songs'
      get '/genres/:genre_name/random_song', to: '#genres#random_song'
    end
  end
end
