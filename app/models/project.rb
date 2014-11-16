class Project < ActiveRecord::Base

  has_many :tasks

  validates :name, 
    presence: true,
    length: { maximum: 500, too_long: "%{count} characters is the maximum allowed" }
  validates :color, 
    presence: true

  validates_format_of :color, 
    with: /#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})/i,
    message: "not a valid hex color"

end
