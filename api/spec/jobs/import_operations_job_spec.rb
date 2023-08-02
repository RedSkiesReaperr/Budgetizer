# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ImportOperationsJob do
  include ActiveJob::TestHelper

  subject(:job) do
    described_class.perform_later(expenses_file: 'spec/vendor/expenses.csv', income_file: 'spec/vendor/incomes.csv')
  end

  after do
    clear_enqueued_jobs
    clear_performed_jobs
  end

  it 'queues the job' do
    expect { job }.to have_enqueued_job
  end

  it 'imports operations in db' do
    perform_enqueued_jobs { job }

    expect(Operation.count).to eq(2)
  end
end
