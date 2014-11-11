class Task < ActiveRecord::Base

  belongs_to :project, dependent: :destroy

  validates :name, 
    presence: true,
    length: { maximum: 500, too_long: "%{count} characters is the maximum allowed" },
    uniqueness: { scope: :project_id }
  validates_inclusion_of :completed, in: [true, false]
  validates :project, 
    presence: true

end
