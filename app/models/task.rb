class Task < ActiveRecord::Base

  belongs_to :project, touch: true

  validates :name, 
    presence: true,
    length: { maximum: 500, too_long: "%{count} characters is the maximum allowed" }
  validates_inclusion_of :completed, { in: [true, false], message: "must be set" }
  validates :project, 
    presence: true

end
