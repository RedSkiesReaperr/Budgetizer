# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OperationsCsv::Sanitizer do
  describe '.sanitize' do
    let(:input) do
      [
        { 'dateOp' => '16/04/1997', 'label' => 'label1', 'amount' => '-863,98 ', 'comment' => nil,
          'supplierFound' => 'supplier' },
        { 'dateOp' => '21/06/2002', 'label' => 'label2', 'amount' => '-33,42 ', 'comment' => 'hello',
          'supplierFound' => 'supplier2' }
      ]
    end

    let(:expected) do
      [
        { date_op: Date.new(1997, 4, 16), label: 'label1', amount: -863.98, comment: '',
          supplier_found: 'supplier' },
        { date_op: Date.new(2002, 6, 21), label: 'label2', amount: -33.42, comment: 'hello',
          supplier_found: 'supplier2' }
      ]
    end

    let(:result) { described_class.new.sanitize(input) }

    it 'returns sanitized lines' do
      expect(result).to eq(expected)
    end
  end
end
