require 'rails_helper'

RSpec.describe ImmediateTaskService do

  context '' do
    let(:current_time) { build(:time) }

    it {
      user = create(:user)
      task_1 = create(:task, :expired, user: user, deadline: current_time - 10.days)
      task_2 = create(:task, :expired, user: user, deadline: current_time - 5.days)
      task_3 = create(:task, :expired, user: user, deadline: current_time - 2.days)

      result =
        Timecop.freeze(current_time) do
          ImmediateTaskService.call
        end

      expect(result).to eq [user]

      expect(result.first['task_id']).to eq task_1.id
    }

    it {
      user = create(:user)
      task_1 = create(:task, :not_expired, user: user, deadline: current_time + 10.days)
      task_2 = create(:task, :not_expired, user: user, deadline: current_time + 5.days)
      task_3 = create(:task, :not_expired, user: user, deadline: current_time + 2.days)

      result =
          Timecop.freeze(current_time) do
            ImmediateTaskService.call
          end

      expect(result).to eq [user]

      expect(result.first['task_id']).to eq task_3.id
    }

    it {
      user = create(:user)
      task_1 = create(:task, :without_deadline, user: user, deadline: nil, created_at: current_time - 1.days)
      task_2 = create(:task, :without_deadline, user: user, deadline: nil, created_at: current_time - 10.days)
      task_3 = create(:task, :without_deadline, user: user, deadline: nil, created_at: current_time - 3.days)

      result =
          Timecop.freeze(current_time) do
            ImmediateTaskService.call
          end

      expect(result).to eq [user]

      expect(result.first['task_id']).to eq task_2.id
    }

    it {
      user_1 = create(:user)
      user_2 = create(:user)
      user_3 = create(:user)

      task_1_1 = create(:task, :expired, user: user_1, deadline: current_time - 10.days)
      task_1_2 = create(:task, :expired, user: user_2, deadline: current_time - 5.days)
      task_1_3 = create(:task, :expired, user: user_3, deadline: current_time - 2.days)

      task_2_1 = create(:task, :not_expired, user: user_1, deadline: current_time + 10.days)
      task_2_2 = create(:task, :not_expired, user: user_2, deadline: current_time + 5.days)
      task_2_3 = create(:task, :not_expired, user: user_3, deadline: current_time + 2.days)

      task_3_1 = create(:task, :without_deadline, user: user_1, deadline: nil, created_at: current_time - 1.days)
      task_3_2 = create(:task, :without_deadline, user: user_2, deadline: nil, created_at: current_time - 10.days)
      task_3_3 = create(:task, :without_deadline, user: user_3, deadline: nil, created_at: current_time - 3.days)

      result =
          Timecop.freeze(current_time) do
            ImmediateTaskService.call
          end

      puts User.all.to_a.inspect
      result = result.sort_by(&:id)

      expect(result).to eq [user_1, user_2, user_3]

      expect(result.first['task_id']).to eq task_1_1.id
      expect(result.second['task_id']).to eq task_1_2.id
      expect(result.third['task_id']).to eq task_1_3.id
    }


    it {
      user_1 = create(:user)
      user_2 = create(:user)
      user_3 = create(:user)
      user_4 = create(:user)

      task_1_3 = create(:task, :expired, user: user_3, deadline: current_time - 2.days)

      task_2_2 = create(:task, :not_expired, user: user_2, deadline: current_time + 5.days)
      task_2_3 = create(:task, :not_expired, user: user_3, deadline: current_time + 2.days)

      task_3_1 = create(:task, :without_deadline, user: user_1, deadline: nil, created_at: current_time - 1.days)
      task_3_2 = create(:task, :without_deadline, user: user_2, deadline: nil, created_at: current_time - 10.days)
      task_3_3 = create(:task, :without_deadline, user: user_3, deadline: nil, created_at: current_time - 3.days)

      result =
          Timecop.freeze(current_time) do
            ImmediateTaskService.call
          end

      result = result.sort_by(&:id)

      expect(result).to eq [user_1, user_2, user_3, user_4]

      expect(result[0]['task_id']).to eq task_3_1.id
      expect(result[1]['task_id']).to eq task_2_2.id
      expect(result[2]['task_id']).to eq task_1_3.id
      expect(result[3]['task_id']).to be nil
    }

    it {
      user_1 = create(:user)
      user_2 = create(:user)
      user_3 = create(:user)
      user_4 = create(:user)

      task_1_3 = create(:task, :expired, user: user_3, deadline: current_time - 2.days, completed_at:  current_time)

      task_2_2 = create(:task, :not_expired, user: user_2, deadline: current_time + 5.days, completed_at:  current_time)
      task_2_3 = create(:task, :not_expired, user: user_3, deadline: current_time + 2.days, completed_at:  current_time)

      task_3_1 = create(:task, :without_deadline, user: user_1, deadline: nil, created_at: current_time - 1.days)
      task_3_2 = create(:task, :without_deadline, user: user_2, deadline: nil, created_at: current_time - 10.days)
      task_3_3 = create(:task, :without_deadline, user: user_3, deadline: nil, created_at: current_time - 3.days, completed_at:  current_time)

      result =
          Timecop.freeze(current_time) do
            ImmediateTaskService.call
          end

      result = result.sort_by(&:id)

      expect(result).to eq [user_1, user_2, user_3, user_4]

      expect(result[0]['task_id']).to eq task_3_1.id
      expect(result[1]['task_id']).to eq task_3_2.id
      expect(result[2]['task_id']).to eq nil
      expect(result[3]['task_id']).to be nil
    }

  end
end

