require 'rails_helper'

RSpec.describe 'ImmediateTaskService' do

  context 'with one user' do
    let(:current_time) { build(:time) }

    it {
      user = create(:user)
      task_1 = create(:task, :expired, user: user)
      task_2 = create(:task, :expired, user: user)

      result =
        Timecop.freeze(current_time) do
          ImmediateTaskService.call
        end

      expect(result).to eq [user]

      puts result.first['task_id']

      # expect( )
    }
  end
end

