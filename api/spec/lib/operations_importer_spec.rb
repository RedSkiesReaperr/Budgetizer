# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OperationsImporter do
  let(:user) { create(:user) }
  let(:file_path) { 'spec/support/attachments/operations_importer.csv' }

  describe '#import' do
    it { expect { described_class.new(user:).import(file_path:) }.to change(Operation, :count).by(3) }
  end
end
