require_relative '../../models/bool_matrix.rb'

class IO::ReadMatrix
  attr_reader :file_path, :true_char, :matrix

  def initialize(file_path, true_char: 'o', matrix: BoolMatrix)
    @file_path = file_path
    @true_char = true_char
    @matrix = matrix
  end

  def call
    array = File.open(file_path,'r').map do |line|
      line.chars.map {|char| char == true_char }
    end

    matrix.new(array)
  end
end
