module Tida
  module NavigationRenderers
    class GlobalMenuRenderer < ::SimpleNavigation::Renderer::Base
      def render(item_container)
        ul_content = item_container.items.inject([]) do |list, item|
          list << item_content(item)
        end.join
        div_content = content_tag :ul, ul_content
        content_tag(:div, div_content, {id: "global-menu"})
      end

      protected

      def item_content(item)
        content_tag :li, tag_for(item)
      end

      def tag_for(item)
        options = options_for(item)
        options = options.merge({rel: 'tooltip', title: item.name, "data-placement" => 'right'})
        link_to content_tag(:span, item.name), item.url, options
      end
    end
  end
end
