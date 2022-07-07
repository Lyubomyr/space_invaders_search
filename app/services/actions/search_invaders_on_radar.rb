module Services
  class SearchInvadersOnRadar
    attr_reader :radar_matrix, :invaders_matrices, :steps

    def initialize(radar_matrix, invaders_matrices, steps: {row: 1, column: 1})
      @radar_matrix = radar_matrix
      @invaders_matrices = invaders_matrices
      @steps = steps
    end

    def call
      invaders_matrices.each.with_index do |invader_matrix, invader_index|
        radar_matrix.clusters.each.with_index do |cluster_coordinates, cluster_index|

          rectangle = find_cluster_rectangle(cluster_coordinates)

          rectangle[:rows_range].each do |row_index|
            rectangle[:columns_range].each do |column_index|

              invader_coordinates = invader_matrix.true_coordinates(row_index, column_index)
              matches_count = (invader_coordinates & cluster_coordinates).count
              chance = (matches_count / invader_matrix.true_count.to_f * 100).round

              next unless radar_matrix.found_invaders[cluster_index].nil? || radar_matrix.found_invaders[cluster_index][:chance] < chance

              radar_matrix.found_invaders[cluster_index] = {
                chance: chance,
                invader_index: invader_index,
                rows_range: row_index..(row_index + invader_matrix.row_count),
                columns_range: column_index..(column_index + invader_matrix.column_count)
              }
            end
          end
        end
      end
    end

  private

    def find_cluster_rectangle(cluster)
      rows = []
      columns = []
      cluster.each{|coordinate| rows.push(coordinate[0]); columns.push(coordinate[1]) }

      {
        rows_range: (rows.min..(rows.max - steps[:row])).to_a,
        columns_range: (columns.min..(columns.max - steps[:column])).to_a
      }
    end
  end
end
