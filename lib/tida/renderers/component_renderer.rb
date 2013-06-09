module Tida
  module Renderers
    module ComponentRenderer
      def render_component(options = {})
        render partial: options[:partial], object: options
      end

      def render_page_title(title)
        toolbar = []
        if block_given?
          yield toolbar
        end
        data = {title: title.html_safe, toolbar: toolbar, partial: 'shared/components/page_title'}
        render_component data
      end

      def render_article_title(title, class_name = nil)
        toolbar = []
        if block_given?
          yield toolbar
        end
        data = {title: title.html_safe, class: class_name, toolbar: toolbar, partial: 'shared/components/article_title'}
        render_component data
      end

      def render_modal_window(name, title, inner_partial)
        data = {name: name, title: title, inner_partial: inner_partial, partial: 'shared/components/modal'}
        render_component data
      end
    end
  end
end
