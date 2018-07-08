require 'optparse'
require 'dotenv/load'
require 'rspotify'
require 'pry' if ENV['DEV']

class PlaylistFetcher
  attr_reader :user_id, :pl_id

  def initialize(pl_url:)
    auth!
    @user_id, @pl_id = parse_pl_url(pl_url)
  end

  def auth!
    @authed = RSpotify.authenticate(ENV['SPOTIFY_CLIENT_ID'], ENV['SPOTIFY_CLIENT_SECRET'])
  end

  def playlist
    @playlist ||= RSpotify::Playlist.find(@user_id, @pl_id)
  end

  def to_json
    raise unless @authed
    tracks = tracks_to_json(playlist.tracks)
    hashed = {
      name: playlist.name,
      description: playlist.description,
      org_url: playlist.href,
      image_url: playlist.images.first.dig('url'),
      created_by: user_id,
      tracks: tracks
    }
    hashed.to_json
  end

  private

    def parse_pl_url(pl_url)
      pl_paths = URI.parse(pl_url).path.split('/')
      user_id = pl_paths[pl_paths.find_index('user') + 1]
      pl_id =   pl_paths[pl_paths.find_index('playlist') + 1]
      [user_id, pl_id]
    end

    def tracks_to_json(sf_tracks)
      sf_tracks.map do |track|
        {
          title: track.name,
          artist: track.artists.first.name,
          album: {
            title: track.album.name,
            tracknumber: track.track_number,
            discnumber: track.disc_number,
            release_date: track.album.release_date
          },
          duration_ms: track.duration_ms,
          org_url: track.href
        }
      end
    end
end

params = ARGV.getopts('u:', 'url')
url = params['u'] || params['url']

fetcher = PlaylistFetcher.new(pl_url: url)
File.open("out/#{fetcher.user_id}_#{fetcher.pl_id}.json", 'w') { |f| f.puts(fetcher.to_json) }
