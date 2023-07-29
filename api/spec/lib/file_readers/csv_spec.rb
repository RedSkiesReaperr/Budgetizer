# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FileReaders::Csv do
  describe '.read' do
    let(:file_path) { 'spec/lib/file_readers/example.csv' }

    it { expect { described_class.read(file_path:) { |l| p l } }.not_to raise_error }

    it 'calls yield for each line' do
      yield_count = 0

      described_class.read(file_path:) { |_| yield_count += 1 }

      expect(yield_count).to eq(4)
    end
  end
end
