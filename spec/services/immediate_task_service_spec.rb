require 'rails_helper'

RSpec.describe 'ImmediateTaskService' do

  context 'with one user' do
    it {
      user = create(:user)
      task = create(:task, user: user)

      puts ImmediateTaskService.call

      # expect( )
    }
  end
end

