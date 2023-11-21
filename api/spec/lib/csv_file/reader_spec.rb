# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CsvFile::Reader do
  let(:result) { described_class.read(file_path:, separator: ';') }

  describe '.read' do
    context 'when file is not well formed' do
      let(:file_path) { Rails.root.join('spec/support/attachments/invalid_separators.csv') }

      it { expect { result }.to raise_error(CSV::MalformedCSVError) }
    end

    context 'when file is well formed' do
      let(:file_path) { Rails.root.join('spec/support/attachments/operations.csv') }

      it { expect { result }.not_to raise_error }

      it { expect(result).to be_a CSV::Table }
    end
  end
end
