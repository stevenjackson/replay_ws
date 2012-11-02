require './lib/replay_ws'
require 'logger'

class ::Logger; alias_method :write, :<<; end
logger = Logger.new('app.log')
use Rack::CommonLogger, logger

run ReplayWS
