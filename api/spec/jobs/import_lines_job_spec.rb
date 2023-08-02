# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ImportLinesJob do
  include ActiveJob::TestHelper

  subject(:job) { described_class.perform_later(budget:) }

  let(:budget) { create(:budget) }

  after do
    clear_enqueued_jobs
    clear_performed_jobs
  end

  it 'queues the job' do
    expect { job }.to have_enqueued_job
  end

  it 'imports lines in db' do
    perform_enqueued_jobs { job }

    expect(Line.count).to be > 0
  end
end
