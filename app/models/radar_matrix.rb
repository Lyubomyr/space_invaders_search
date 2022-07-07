require_relative './bool_matrix'

class RadarMatrix < BoolMatrix
  SIBLINGS_OFFSETS = [-1, 0, 1]

  attr_accessor :clusters, :found_invaders

  def initialize(*)
    super

    @clusters = []
    @found_invaders = {}
  end

  def find_true_siblings_indexes(row_index, column_index)
    siblings = SIBLINGS_OFFSETS.map do |sibling_row_offset|
                 SIBLINGS_OFFSETS.map do |sibling_column_offset|
                   sibling_row_index = row_index + sibling_row_offset
                   sibling_column_index = column_index + sibling_column_offset

                   [sibling_row_index, sibling_column_index] if find_element_inside(sibling_row_index, sibling_column_index)
                 end
               end
    siblings.flatten(1).compact
  end

private

  def find_element_inside(row_index, column_index)
    inside_boundaries = row_index >= 0 && column_index >= 0 && row_index < row_count && column_index < column_count
    return nil unless inside_boundaries

    matrix[row_index, column_index]
  end

end
