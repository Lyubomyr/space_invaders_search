require_relative './application.rb'

RADAR_NAME = 'radar_sample'.freeze
INVADER_NAMES = %w(invader_bug invader_medusa).freeze

Application.new(RADAR_NAME, INVADER_NAMES).call
