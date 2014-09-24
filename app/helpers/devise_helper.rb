module DeviseHelper
  def devise_error_messages!
    resource.errors.full_messages.map { |msg| content_tag(:p, msg) }.join
  end
end