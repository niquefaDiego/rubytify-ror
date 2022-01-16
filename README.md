# Rubytify

## Dependencies

### Required environment variables:

The following envinronment variables should be set:

```
SPOTIFY_CLIENT_ID=
SPOTIFY_CLIENT_SECRET=
SPOTIFY_API_URL=https://api.spotify.com
SPOTIFY_AUTH_ENDPOINT_URL=https://accounts.spotify.com/api/token
```

## Spotify

Documentation: https://developer.spotify.com/documentation/web-api/reference

## Instructions

- For the rubytify instructions check this gist: https://gist.github.com/AyendaHoteles/235cd0955799dfc1c9ec5fa28d00f2ae 
- To upload the code create your own fork of this repo and start a pull request to this repo once you're done with your changes.


## Comments

One could use this instead: https://github.com/guilhermesad/rspotify

## Generating models

bin/rails generate model Artist name:string image_url:text genres:string popularity:integer:index spotify_url:text spotify_id:string:uniq 
bin/rails generate model Album artist:references name:string image_url:text spotify_url:text total_tracks:integer spotify_id:string:uniq
bin/rails generate model Song album:references name:string spotify_url:text preview_url:text duration_ms:integer explicit:boolean spotify_id:string:uniq
bin/rails generate model SongGenre song:references genre:string:index
