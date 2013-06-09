#encoding: utf-8
module ApplicationHelper
  include ::Tida::Renderers::ComponentRenderer

  def render_attribute(obj, attr_name)
    name = t("activerecord.attributes.#{obj.class.name.underscore}.#{attr_name}")
    value = ''
    value = obj.send(attr_name) unless obj.nil?
    "<strong>#{name}:</strong> #{value}".html_safe
  end

  def render_icon_and_text_content(icon_name, text)
    content = []
    content << content_tag(:i, nil, class: icon_name)
    content << content_tag(:span, text)
    content.join(" ").html_safe
  end

  def render_icon_content(icon_name)
    content_tag(:i, nil, class: icon_name)
  end

  def render_progress_bar(label)
    label_content = content_tag :span, label
    bar_content = content_tag :div, label_content, class: 'bar', style: 'width: 100%;'
    content_tag :div, bar_content, class: 'progress progress-striped active'
  end

  def highlight_menu(controller)
    controllers = Array(controller)
    controller.include? controller_name
  end

  def render_mission_running_status(mission)
    if mission.is_performed?
      return render_progress_bar("Running...")
    end
  end

  def render_mission_result_status(mission)
    if mission.is_enqueued?
      return content_tag :i, nil, class: "icon-time blue"
    elsif mission.is_completed?
      return content_tag :i, nil, class: "icon-ok-sign green"
    elsif mission.is_failed?
      return content_tag :i, nil, class: "icon-warning-sign red"
    end
  end

  def render_media_position(launch)
    name = nil
    class_name = 'label'
    case launch.media_position_id
    when 1
      name = '首页'
      class_name += ' label-danger'
    when 2
      name = '板块首页'
      class_name += ' label-warning'
    else
      name = '其他版面'
    end
    content_tag :span, name, class: class_name
  end

  def render_media_ad_style(launch)
    name = nil
    class_name = 'label'
    case launch.ad_style_id
    when 1
      name = '首页焦点图'
      class_name += ' label-danger'
    when 2
      name = '要闻文字链'
      class_name += ' label-warning'
    else
      name = '文字链'
    end
    content_tag :span, name, class: class_name
  end
end
