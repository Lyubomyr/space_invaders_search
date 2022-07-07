require 'matrix'

class BoolMatrix
  attr_reader :matrix, :count, :row_count, :column_count, :true_count

  def initialize(init_array)
    @matrix = Matrix[*init_array]

    @count = matrix.count
    @row_count = @matrix.row_count
    @column_count = @matrix.column_count
    @true_count = matrix.select{|element| element }.count
  end

  def true_coordinates(init_row_index = 0, init_column_index = 0)
    matrix.each_with_index.map do |el, row, column|
      [row + init_row_index, column + init_column_index] if el
    end.compact
  end
end
