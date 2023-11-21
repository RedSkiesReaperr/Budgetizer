# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OperationsCsv::Validator do
  describe '.validate' do
    let(:content) { CSV::Table.new(rows, headers: %w[dateOp label amount comment supplierFound]) }

    context 'when content is empty' do
      let(:rows) { [] }

      it { expect { described_class.new.validate(content) }.to raise_error(CsvFile::Errors::EmptyFileError) }
    end

    context 'when mandatory header is missing' do
      let(:rows) do
        [
          CSV::Row.new(%w[dateOp label amount comment], [])
        ]
      end

      it { expect { described_class.new.validate(content) }.to raise_error(CsvFile::Errors::MissingHeaderError) }
    end

    context 'when csv is valid' do
      let(:rows) do
        [
          CSV::Row.new(%w[dateOp label amount comment supplierFound], %w[date1 label1 12.93 comment uber])
        ]
      end

      it { expect { described_class.new.validate(content) }.not_to raise_error }
    end
  end
end
