require_relative '../../app/models/bool_matrix'

RSpec.describe BoolMatrix do
  let(:init_array) { [[true, false], [false, true], [true, true]] }
  subject { described_class.new(init_array) }

  describe '#initialize' do
    context 'should raise error' do
      it 'when array is not matrix-like (amount of elements in rows/columns are different)' do
        expect { described_class.new([[true, false], [true, false, false]]) }.to raise_error
      end
    end

    context 'should initialize instance' do
      it 'with 2 levels matrix-like array and return it' do
        expect(subject).to be_a(described_class)
      end

      it 'with proper list of attributes' do
        expect(subject).to have_attributes({ matrix: init_array,
                                                 count: 6,
                                                 row_count: 3,
                                                 column_count: 2,
                                                 true_count: 4 })
      end
    end
  end

  describe '#true_coordinates' do
    context 'should return coordinates of all true elements' do
      it '' do
        expect(subject.true_coordinates).to eq [[0, 0], [1, 1], [2, 0], [2, 1]]
      end

      it 'with shift when provide initial coordinates' do
        expect(subject.true_coordinates(1, 2)).to eq [[1, 2], [2, 3], [3, 2], [3, 3]]
      end
    end
  end
end
