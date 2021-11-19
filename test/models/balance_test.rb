# == Schema Information
#
# Table name: balances
#
#  id         :bigint           not null, primary key
#  amount     :decimal(, )
#  date       :date
#  location   :string
#  variation  :decimal(, )
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
# Indexes
#
#  index_balances_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require "test_helper"

class BalanceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
