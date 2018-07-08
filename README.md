# usage

```console
$ bundle install
$ cp .env.template .env && vim .env

$ bundle exec ruby spotify-export-pl.rb -u 'https://open.spotify.com/user/spotify/playlist/37i9dQZF1DXdLtD0qszB1w' -f
saved playlist json to "./out/This Is The Beatles (spotify).json"

$ head "./out/This Is The Beatles (spotify).json"
{
  "name": "This Is The Beatles",
  "description": "Come together to listen to their greatest hits.",
  "org_url": "https://api.spotify.com/v1/users/spotify/playlists/37i9dQZF1DXdLtD0qszB1w",
  "image_url": "https://i.scdn.co/image/d8b5785e622b94c7bd1d082a8745ce16aff593d3",
  "created_by": "spotify",
  "tracks": [{
    "title": "Sgt. Pepper's Lonely Hearts Club Band - Remastered",
    "artist": "The Beatles",
    "album": {
```
