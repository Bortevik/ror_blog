class Assignment < ActiveRecord::Base
  attr_accessible :role_id

  belongs_to :user
  belongs_to :role
end
