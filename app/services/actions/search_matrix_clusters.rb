require_relative '../../models/bool_matrix'

module Services
  class SearchMatrixClusters
    CLUSTER_SEARCH_ACCURACY = 6.freeze # In matrix one element could have 8 sibling + self element = 9. How many siblings should have element to call this area densely populated and search for the cluster arround.

    attr_reader :radar_matrix, :steps, :matrix_element_siblings, :cluster_search_accuracy

    def initialize(radar_matrix, steps: {row: 1, column: 1}, cluster_search_accuracy: CLUSTER_SEARCH_ACCURACY)
      @radar_matrix = radar_matrix
      @steps = steps
      @cluster_search_accuracy = cluster_search_accuracy
    end

    def call
      row_steps_count = radar_matrix.row_count / steps[:row]
      column_steps_count = radar_matrix.column_count / steps[:column]

      (1..row_steps_count).to_a.each do |row_index|
        matrix_row_index = row_index * steps[:row] - 1

        (1..column_steps_count).to_a.each do |column_index|
          matrix_column_index = column_index * steps[:column] - 1

          @matrix_element_siblings = radar_matrix.find_true_siblings_indexes(matrix_row_index, matrix_column_index)

          next if matrix_element_siblings.count < cluster_search_accuracy || matrix_elements_in_cluster?(matrix_element_siblings)

          radar_matrix.clusters.push find_all_cluster_elements
        end
      end
    end

    private

    def matrix_elements_in_cluster?(elements)
      !!radar_matrix.clusters.find{|cluster| !(cluster & elements).empty? }
    end

    def find_all_cluster_elements
      cluster_elements = []

      while matrix_element_siblings[0]
        cluster_elements << matrix_element_siblings[0]
        new_siblings = radar_matrix.find_true_siblings_indexes(matrix_element_siblings[0][0], matrix_element_siblings[0][1])
        @matrix_element_siblings.push(*new_siblings)
        @matrix_element_siblings -= cluster_elements
      end

      cluster_elements.sort
    end
  end
end
