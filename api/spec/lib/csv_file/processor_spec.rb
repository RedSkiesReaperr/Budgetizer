# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CsvFile::Processor do
  describe '.process' do
    let(:file_path) { 'any' }
    let(:validator) { double('validator', validate: true) }
    let(:sanitizer) { double('sanitizer', sanitize: { sanitized: 'data' }) }
    let(:processor) { described_class.new(file_path:, validator:, sanitizer:) }
    let(:fake_content) { 'any content data' }

    before do
      allow(CsvFile::Reader).to receive(:read).with(file_path:).and_return(fake_content)

      processor.process
    end

    it { expect(validator).to have_received(:validate).with(fake_content).once }

    it { expect(sanitizer).to have_received(:sanitize).with(fake_content).once }

    it 'returns sanitized data' do
      expect(processor.process).to eq({ sanitized: 'data' })
    end
  end
end
