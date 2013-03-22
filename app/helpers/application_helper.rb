module ApplicationHelper
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def signed_in?
    !!current_user
  end

  def nav_link(text, path)
    current = current_page?(path)
    content_tag(:li, link_to(text, path), :class => current ? 'current' : nil)
  end
end
