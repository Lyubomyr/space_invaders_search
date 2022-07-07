class IO::PrintRadar
  attr_reader :radar_matrix, :invaders_matrix, :found_invaders

  def initialize(radar_matrix, invaders_matrix, found_invaders)
    @radar_matrix = radar_matrix
    @invaders_matrix = invaders_matrix
    @found_invaders = found_invaders
  end

  def call
    radar_matrix.matrix.each_with_index do |el, row, column|
      invader_location = found_invaders.values.find{|invader| invader[:rows_range].include?(row) && invader[:columns_range].include?(column)}
      invader_element = nil

      if invader_location
        invader_matrix = invaders_matrix[invader_location[:invader_index]].matrix
        invader_element = invader_matrix[row - invader_location[:rows_range].first, column - invader_location[:columns_range].first]
        invader_element = found_invaders.key(invader_location) + 1 if invader_element
      end

      print_element = invader_element || '-'
      print_element += "\n" if column + 1 == radar_matrix.column_count

      print print_element
    end
  end
end
