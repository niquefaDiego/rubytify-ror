# Rubytify

Deployed API URL: https://thawing-shelf-12867.herokuapp.com

Sample requests:
- https://thawing-shelf-12867.herokuapp.com/api/v1/artists
- https://thawing-shelf-12867.herokuapp.com/api/v1/artists/3Nrfpe0tUJi4K4DXYWgMUX/albums
- https://thawing-shelf-12867.herokuapp.com/api/v1/albums/6nYfHQnvkvOTNHnOhDT3sr/songs
- https://thawing-shelf-12867.herokuapp.com/api/v1/genres/k-pop/random_song


## Local setup

The following envinronment variables should be set:

### Environment variables

```
SPOTIFY_CLIENT_ID=
SPOTIFY_CLIENT_SECRET=
SPOTIFY_API_URL=https://api.spotify.com
SPOTIFY_AUTH_ENDPOINT_URL=https://accounts.spotify.com/api/token
```

You can set them in `config/local_env.yml`.


### Database

A postgres instance is required, you can start it by running:

```
docker-compose up -d
```

You can explore the development and test databases as follows:

```
psql -h localhost -U dbuser -d rubytify_development
psql -h localhost -U dbuser -d rubytify_test
```


## Unit Testing

Run normal tests:
```
bin/rails test
```


Run RSpec tests:

```
bundle exec rspec
```

## Spotify integration


To import spotify data for the albums, tracks and genres of the artists in `/lib/tasks/spotify_artists.ytml` run:

```
rake spotify:import
```

Spotify API aocumentation: https://developer.spotify.com/documentation/web-api/reference

## Deployment command

```
git push heroku master
```
