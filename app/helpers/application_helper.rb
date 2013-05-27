module ApplicationHelper

  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "RoR Blog"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def icon(type)
    content_tag(:i, nil, class: "icon-#{type}")
  end

  def tags
    tags ||= Tag.all
  end

  def markdown(text)
    renderer = Redcarpet::Render::HTML.new(hard_wrap: true, filter_html: true)
    options = {
      autolink: true,
      no_intra_emphasis: true,
      fenced_code_blocks: true,
      disable_indented_code_blocks: true,
      lax_spacing: true,
      strikethrough: true,
      superscript: true,
      space_after_headers: true,
      underline: true
    }
    Redcarpet::Markdown.new(renderer, options).render(text).html_safe
  end
end
