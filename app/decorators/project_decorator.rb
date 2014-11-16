class ProjectDecorator < Draper::Decorator
  delegate_all

  def updated_since_epoch
    object.updated_at.to_i * 1000
  end

end
