require_relative '../../app/models/radar_matrix'

RSpec.describe RadarMatrix do
  let(:init_array) { [[true, false, false, false],
                      [false, true, true, false],
                      [true, true, true, true],
                      [true, false, true, true],
                      [true, true, false, true]] }
  subject { described_class.new(init_array) }

  describe '#initialize' do
    context 'should initialize instance' do
      it 'with parent attributes' do
        expect(subject).to have_attributes({ matrix: init_array,
                                                 count: 20,
                                                 row_count: 5,
                                                 column_count: 4,
                                                 true_count: 13 })
      end

      it 'with own attributes' do
        expect(subject).to have_attributes({ clusters: [],
                                                 found_invaders: {}})
      end
    end
  end

  describe '#find_element_inside' do
    it 'should return element when its inside the matrix' do
      expect(subject.send(:find_element_inside, 1, 1)).to eq true
    end

    it 'should return nil when element outside the matrix' do
      expect(subject.send(:find_element_inside, 5, 5)).to eq nil
    end
  end

  describe '#find_true_siblings_indexes' do
    it 'should return indexes of all element siblings and indexes of the element by itself' do
      expect(subject.find_true_siblings_indexes(2, 1)).to eq [[1, 1], [1, 2], [2, 0], [2, 1], [2, 2], [3, 0], [3, 2]]
    end

    it 'should not return element outside the matrix or false element' do
      expect(subject.find_true_siblings_indexes(0, 0)).to eq [[0, 0], [1, 1]]
    end
  end
end
