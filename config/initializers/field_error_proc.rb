ActionView::Base.field_error_proc = proc do |html_tag, instance|
  content_tag :div, class: 'has-validation' do
    concat html_tag
    binding.irb
    concat content_tag(:div, instance.error_message.join(', '), class: 'invalid-feedback')
  end
end

module ActionView::Helpers::ActiveModelInstanceTag
  def error_message
    object.errors.full_messages_for(@method_name)
  end
end
