# == Schema Information
#
# Table name: admin_users
#
#  id                     :bigint           not null, primary key
#  confirmation_sent_at   :datetime
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string(255)
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  failed_attempts        :integer          default(0), not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string(255)
#  locked_at              :datetime
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  sign_in_count          :integer          default(0), not null
#  unconfirmed_email      :string(255)
#  unlock_token           :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_admin_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_admin_users_on_email                 (email) UNIQUE
#  index_admin_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_admin_users_on_unlock_token          (unlock_token) UNIQUE
#
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

  describe 'ransackable_attributes' do
    it 'spec coverage' do
      expect(described_class.ransackable_attributes.class).to eq(Array)
    end
  end
end
