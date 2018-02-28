module ApplicationHelper
  include SimpleAuthentication::Authenticate::LocalInstanceMethods

  def markdownify(content)
    pipeline_context = { gmf: true, asset_root: "https://a248.e.akamai.net/assets.github.com/images/icons/"}
    pipeline = HTML::Pipeline.new [
      HTML::Pipeline::MarkdownFilter,
      HTML::Pipeline::EmojiFilter,
      HTML::Pipeline::SanitizationFilter,
      HTML::Pipeline::SyntaxHighlightFilter,
      HTML::Pipeline::TableOfContentsFilter,
    ], pipeline_context
    pipeline.call(content)[:output].to_s.html_safe
  end
end
