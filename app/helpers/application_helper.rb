module ApplicationHelper

  #Get view pages's full title base on it's page title
  def full_title(page_title)
    base_title = "Ruby on Rails Tutorial Sample App"

    if page_title.nil?
      return base_title
    else
      return base_title += " | #{page_title}"
    end
  end
end

