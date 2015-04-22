module ApplicationHelper
  # include FontAwesome::Rails::IconHelper

	def full_title(page_title = '')
		base_title = "Swat Course Review"
		if page_title.empty?
			base_title
		else
			"#{page_title} | #{base_title}"
		end
	end
end
