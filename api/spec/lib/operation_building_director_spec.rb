# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OperationBuildingDirector do
  let(:user) { create(:user) }

  describe '.build_operation' do
    let(:builder) { instance_double(OperationBuilder) }
    let(:res) do
      described_class.new(user).build_operation({ date_op: Time.zone.today, label: 'label', amount: 87.24,
                                                  comment: 'comment', supplier_found: 'supplier' })
    end

    before do
      allow(OperationBuilder).to receive(:new).and_return(builder)
      allow(builder).to receive(:build_date).with(Time.zone.today)
      allow(builder).to receive(:build_label).with('label')
      allow(builder).to receive(:build_amount).with(87.24)
      allow(builder).to receive(:build_pointed).with(false)
      allow(builder).to receive(:build_op_type).with('label', 'supplier', 87.24)
      allow(builder).to receive(:build_category)
      allow(builder).to receive(:build_user).with(user)
      allow(builder).to receive(:result).and_return('builded operation')
    end

    it { expect { res }.not_to raise_error }

    it { expect(res).to eq('builded operation') }
  end
end
