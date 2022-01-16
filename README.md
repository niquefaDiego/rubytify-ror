# Rubytify

### Required environment variables:

The following envinronment variables should be set:

```
SPOTIFY_CLIENT_ID=
SPOTIFY_CLIENT_SECRET=
SPOTIFY_API_URL=https://api.spotify.com
SPOTIFY_AUTH_ENDPOINT_URL=https://accounts.spotify.com/api/token
```

## Local setup

Postgres is required in the local setup, you can start it by running:

```
docker-compose up -d
```


You can explore the development and test databases as follows:

```
psql -h localhost -U dbuser -d rubytify_development
psql -h localhost -U dbuser -d rubytify_test
```


## Spotify integration


To import spotify data for the albums, tracks and genres of the artists in `/lib/tasks/spotify_artists.ytml` run:

```
rake spotify:import
```

Spotify API aocumentation: https://developer.spotify.com/documentation/web-api/reference

## Instructions

- For the rubytify instructions check this gist: https://gist.github.com/AyendaHoteles/235cd0955799dfc1c9ec5fa28d00f2ae 
- To upload the code create your own fork of this repo and start a pull request to this repo once you're done with your changes.


# Deployment

```
git push heroku master
```
