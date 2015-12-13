module ApplicationHelper
  def page_title(title, &block)
    page_actions = block_given? ? capture(&block) : ''
    content_tag(:div, class: "page-header") do
      content_tag(:h1, (title + page_actions).html_safe)
    end
  end

  def page_subtitle(title, &block)
    page_actions = block_given? ? capture(&block) : ''
    content_tag(:div, class: "sub-header") do
      content_tag(:h2, (title + page_actions).html_safe)
    end
  end
end
