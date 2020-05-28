class QuestionPresenter < ApplicationPresenter
  presents :question

  @delegation_methods = [:content]

  delegate *@delegation_methods, to: :question

  def display_markdown_content
    options = {
      hard_wrap: true, 
      filter_html: true, 
      autolink: true, 
      no_intraemphasis: true, 
      fenced_code: true, 
      gh_blockcode: true
    }
    redcarpet = Redcarpet::Markdown.new(Redcarpet::Render::HTML, options)
    redcarpet.render(content).html_safe
  end
end
