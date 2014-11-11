class Project < ActiveRecord::Base

  COLORS = %w( 44aa00 3399aa ee44FF ).freeze

  has_many :tasks

  validates :name, 
    presence: true,
    length: { maximum: 500, too_long: "%{count} characters is the maximum allowed" }
  validates :color, 
    presence: true, 
    inclusion: { in: COLORS, message: "is not a valid color" }



end
