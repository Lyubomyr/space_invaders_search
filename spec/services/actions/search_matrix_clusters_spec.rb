require_relative '../../../app/services/actions/search_matrix_clusters'
require_relative '../../../app/models/radar_matrix'

RSpec.describe Services::SearchMatrixClusters do
  let (:matrix_array) { [[true, false, true, false],
                         [true, false, false, true],
                         [false, true, false, true],
                         [false, true, false, false]] }
  let(:radar_matrix) { double('RadarMatrix', matrix: matrix_array,
                                             row_count: 4,
                                             column_count: 4 )}
  let(:steps) { {row: 1, column: 1} }
  subject { described_class.new(radar_matrix, steps: steps) }

  describe '#initialize' do
    it 'should initialize instance with proper list of attributes' do
      expect(subject).to have_attributes({ radar_matrix: radar_matrix,
                                           steps: steps,
                                           cluster_search_accuracy: 6 })
    end
  end

  describe '#matrix_elements_in_cluster?' do
    before { expect(radar_matrix).to receive(:clusters).and_return([[[0, 0],[1, 0]], [[1, 2]]]) }

    context 'should return true' do
      it ' when some of attribute elements already in cluster' do
        elements = [[0, 0]]
        expect(subject.send(:matrix_elements_in_cluster?, elements)).to eq true
      end

      it ' when all of attribute elements already in cluster' do
        elements = [[0, 0],[1, 0]]
        expect(subject.send(:matrix_elements_in_cluster?, elements)).to eq true
      end
    end

    context 'should return false' do
      it ' when attribute elements are not in cluster' do
        elements = [[0,1], [2,1]]
        expect(subject.send(:matrix_elements_in_cluster?, elements)).to eq false
      end
    end
  end

  describe '#find_all_cluster_elements' do
    it 'should return list of indexes of true elements which are laying near by horizontal, vertical or diagonal' do
      subject.instance_variable_set(:@matrix_element_siblings, [[0, 0]])
      expect(radar_matrix).to receive(:find_true_siblings_indexes).with(0, 0).and_return([[0, 0],[1, 0]])
      expect(radar_matrix).to receive(:find_true_siblings_indexes).with(1, 0).and_return([[0, 0], [1, 0], [2, 1]])
      expect(radar_matrix).to receive(:find_true_siblings_indexes).with(2, 1).and_return([[1, 0],[1, 2], [2, 1], [3, 1]])
      expect(radar_matrix).to receive(:find_true_siblings_indexes).with(1, 2).and_return([[1, 2],[2, 1]])
      expect(radar_matrix).to receive(:find_true_siblings_indexes).with(3, 1).and_return([[2, 1],[3, 1]])
      expect(subject.send(:find_all_cluster_elements)).to eq [[0, 0], [1, 0], [1, 2], [2, 1], [3, 1]]
    end
  end

  describe '#call' do
    it 'should set all matrix clusters indexes to matrixs clusters variable' do
      radar_matrix = RadarMatrix.new(matrix_array)
      subject = described_class.new(radar_matrix, steps: steps, cluster_search_accuracy: 2)
      subject.call
      expect(radar_matrix.clusters).to eq [[[0, 0], [1, 0], [2, 1], [3, 1]], [[0, 2], [1, 3], [2, 3]]]
    end
  end
end
