require 'rails_helper'

describe AdminUser do
  describe 'audited' do
    before(:each) { described_class.auditing_enabled = true }
    after(:each) { described_class.auditing_enabled = true }

    it { should be_audited }
  end

  describe 'scopes' do
    context 'locked/active' do
      it 'should only include users for which their account has been locked' do
        user1 = create(:admin_user)
        user2 = create(:admin_user, :locked_at => Time.now)
        expect(described_class.active.pluck(:id)).to eq([user1.id])
        expect(described_class.locked.pluck(:id)).to eq([user2.id])
      end
    end
  end
end
