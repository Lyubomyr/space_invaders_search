require 'pry'
require_relative './app/services/io/read_matrix.rb'
require_relative './app/services/io/print_radar.rb'
require_relative './app/services/actions/search_matrix_clusters.rb'
require_relative './app/services/actions/search_invaders_on_radar.rb'
require_relative './app/models/radar_matrix.rb'

class Application
  FILES_FOLDER = 'app/files'

  attr_reader :radar_name, :invader_names, :files_resolution, :radar_matrix, :invaders_matrices, :steps

  def initialize(radar_name, invader_names, files_resolution: 'txt')
    @radar_name = radar_name
    @invader_names = invader_names
    @files_resolution = files_resolution
  end

  def call
    read_matrixces
    find_dimentions

    Services::SearchMatrixClusters.new(radar_matrix, steps: steps).call # To not itterate all over the radar matrix, lets first find all clusters of elements inside the radar.

    Services::SearchInvadersOnRadar.new(radar_matrix, invaders_matrices, steps: steps).call # Lets find all chances of invaders existance inside found clusters and choose biggest for each cluster

    print_result(radar_matrix.found_invaders)
  end

  def read_matrixces
    @radar_matrix = IO::ReadMatrix.new(file_path(radar_name), matrix: RadarMatrix).call
    @invaders_matrices = invader_names.map{|name| IO::ReadMatrix.new(file_path(name)).call}
  end

  def find_dimentions
    invaders_min_height = invaders_matrices.map(&:row_count).min
    invaders_min_width = invaders_matrices.map(&:column_count).min

    step_row = invaders_min_height / 2 # Lets move through radar in most efficient way using half of smaller invader size
    step_column = invaders_min_width / 2
    @steps = {row: step_row, column: step_column}
  end

  def print_result(result)
    puts "On radar we found #{result.count} invaders with the next chances: #{result.values.map{|invader| invader[:chance].to_s + '%'}.join(', ') } respectively"
    IO::PrintRadar.new(radar_matrix, invaders_matrices, result).call
  end

private

  def file_path(file_name)
    File.join(File.dirname(__FILE__), FILES_FOLDER, "#{file_name}.#{files_resolution}")
  end
end
