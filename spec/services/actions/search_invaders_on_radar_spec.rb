require_relative '../../../app/services/actions/search_invaders_on_radar'
require_relative '../../../app/models/radar_matrix'
require_relative '../../../app/models/bool_matrix'

RSpec.describe Services::SearchInvadersOnRadar do
  let(:matrix_array) { [[true, false, false, false, true, false],
                        [true, false, false, true, true, true],
                        [false, true, false, true, true, false],
                        [true, true, false, true, true, false],
                        [true, true, false, true, true, true],
                        [true, false, false, true, false, false],
                        [true, true, false, true, false, false],
                        [false, true, false, false, true, false]] }
  let(:radar_matrix) { RadarMatrix.new matrix_array }
  let(:bug_invader) { BoolMatrix.new [[true, false, false, false], [false, true, false, false], [true, true, true, false], [true, true, true, false]] }
  let(:medusa_invader) { BoolMatrix.new [[true, false, false], [true, true, true], [true, true, true], [true, false, true]] }
  let(:invaders_matrices) { [bug_invader, medusa_invader] }
  let(:steps) { {row: 1, column: 1} }
  subject { described_class.new(radar_matrix, invaders_matrices, steps: steps) }

  describe '#initialize' do
    it 'should initialize instance with proper list of attributes' do
      expect(subject).to have_attributes({ radar_matrix: radar_matrix,
                                           invaders_matrices: invaders_matrices,
                                           steps: steps })
    end
  end

  describe '#find_cluster_rectangle' do
    it 'should return correct indexes of extreme points of cluser(array of indexes)' do
      cluster = [[0, 0], [1, 0], [2, 1], [3, 1]]
      expect(subject.send(:find_cluster_rectangle, cluster)).to eq({ columns_range: [0],
                                                                     rows_range: [0, 1, 2] })
    end
  end

  describe '#call' do
    it 'should return correct indexes of extreme points of cluser(array of indexes)' do
      radar_matrix.clusters = [[[0, 0], [1, 0], [2, 1], [3, 0], [3, 1], [4, 0], [4, 1], [5, 0], [6, 0], [6, 1], [7, 1]], [[0, 4], [1, 3], [1, 4], [1, 5], [2, 3], [2, 4], [3, 3], [3, 4], [4, 3], [4, 4], [4, 5], [5, 3], [5, 5], [6, 3], [7, 4]]]
      subject.call

      expect(radar_matrix.found_invaders).to eq({ 0 => { chance: 75,
                                                         columns_range: 0..4,
                                                         invader_index: 0,
                                                         rows_range: 1..5 },
                                                  1 => { chance: 89,
                                                         columns_range: 3..6,
                                                         invader_index: 1,
                                                         rows_range: 2..6 } })
    end
  end
end
