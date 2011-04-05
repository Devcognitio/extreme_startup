require 'rubygems'
require 'sinatra'
require 'httparty'
require 'uuid'
require 'haml'
require_relative 'ip'

configure do
  set :port, 3000
end

class Scoreboard
  attr_reader :scores
  
  def initialize
    @scores = Hash.new { 0 }
  end
  
  def increment_score_for(player_uuid)
    @scores[player_uuid] += 1
  end
  
  def leaderboard
    @scores.sort{|a,b| a[1]<=>b[1]}.reverse
  end
end

class Shopper
  def initialize(player, scoreboard)
    @player = player
    @scoreboard = scoreboard
  end
  
  def start
    while true
      response = HTTParty.get(@player.url)
      @scoreboard.increment_score_for(@player.uuid)
      puts "player #{@player.name} said #{response}"
      sleep 5
    end
  end
end

class Player
  attr_reader :name, :url, :uuid
  
  def initialize(params)
    @name = params['name']
    @url = params['url']
    @uuid = $uuid_generator.generate.to_s[0..7]
  end
  
  def to_s
    "#{name} (#{url})"
  end
end

$uuid_generator = UUID.new
$players = Hash.new
$scoreboard = Scoreboard.new

get '/' do 
  haml :leaderboard, :locals => { :leaderboard => $scoreboard.leaderboard, :players => $players  }
end

get %r{/players/([\w]+)} do |uuid|
  haml :personal_page, :locals => { :name => $players[uuid].name, :score => $scoreboard.scores[uuid] }
end

get '/players' do
  haml :add_player
end

Thread.abort_on_exception = true

post '/players' do
  player = Player.new(params)
  Thread.new { Shopper.new(player, $scoreboard).start }
  $players[player.uuid] = player
  
  personal_page = "http://#{local_ip}:#{@env["SERVER_PORT"]}/players/#{player.uuid}"
  
  haml :player_added, :locals => { :url => personal_page }
end