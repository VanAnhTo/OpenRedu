module SpacesHelper


  def submission_type(space)
    case space.submission_type
    when 1
      'Todos, sem moderação'
    when 2
      'Todos, com moderação'
    when 3
      'Apenas professores'
    end
  end

   def subscription_type(space)
     case space.subscription_type
     when 1
       'Livre'
     when 2
       'Moderado'
     when 3
       'Restrito'
     end
  end

  def columnize_categories(number_of_columns = 3)

   @categories = ReduCategory.find(:all)

    html = ''

   breakdiv = @categories.size/number_of_columns + 1

   @translated_categories = @categories.each {|c| c.name = t(c.name.downcase.gsub(' ','_').to_sym) }
   @translated_categories.sort! { |a,b| a.name <=> b.name }



   @translated_categories.each_with_index do |category, idx|
     html += (idx%breakdiv == 0 and idx != 0) ? '</div>' : ''
     html +=  (idx%breakdiv == 0) ? '<div style="float: left;">' : ''
     html +=  '<div>'
     html +=  check_box_tag "space[category_ids][]", category.id, @space.categories.include?(category)
     html += category.name
     html += '</div>'

  end
  html += '</div>'

  end

   # used to know if a topic has changed since we read it last
  def recent_topic_activity(topic)
    return false if not logged_in?
    return false unless last_active || session[:topics]

    return topic.replied_at > (last_active || session[:topics][topic.id])
  end

  # used to know if a forum has changed since we read it last
  def recent_forum_activity(forum)
    return false unless logged_in? && forum.topics.first
    return false unless last_active || session[:forums]

    return forum.recent_topics.first.replied_at > (last_active || session[:forums][forum.id])
  end

  def icon_and_color_and_post_for(topic)
    icon = "comment"
    color = ""
    post = ''
    if topic.locked?
      icon = "lock"
      post = ", "+ t( :this_topic_is_locked )
      color = "darkgrey"
    end
    [icon, color, post  ]
  end

  def space_association_pending?
    (current_user.spaces.include?(@space) && current_user.get_association_with(@space).status == "pending")
  end

  def space_association_disaproved?
    current_user.spaces.include?(@space) && current_user.get_association_with(@space).status == "disaproved"
  end

end
