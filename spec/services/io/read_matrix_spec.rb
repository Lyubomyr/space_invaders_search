require_relative '../../../app/services/io/read_matrix'

RSpec.describe IO::ReadMatrix do
  let(:file_path) { 'some_path' }
  let(:file_content) { ['o-o', 'oo-'] }
  let(:file_content_to_bool) { [[false, false, false], [false, false, false]] }
  let(:matrix_content) { 'matrix_content' }
  let(:bool_matrix_class) { double('BoolMatrix') }
  let(:radar_matrix_class) { double('RadarMatrix') }
  let(:true_char) { '+' }
  subject { described_class.new(file_path, true_char: true_char, matrix: bool_matrix_class) }
  let(:read_matrix_radar) { described_class.new(file_path, matrix: radar_matrix_class) }

  describe '#initialize' do
    context 'should initialize instance' do
      it 'with proper list of attributes' do
        expect(subject).to have_attributes({ file_path: file_path,
                                                 true_char: true_char,
                                                 matrix: bool_matrix_class })
      end

      it 'different matrix class' do
        expect(read_matrix_radar).to have_attributes({ matrix: radar_matrix_class })
      end
    end
  end

  describe '#call' do
    it 'should init matrix from file data' do
      expect(File).to receive(:open).and_return(file_content)
      expect(bool_matrix_class).to receive(:new).with(file_content_to_bool).and_return(matrix_content)
      expect(subject.call).to eq matrix_content
    end
  end
end
