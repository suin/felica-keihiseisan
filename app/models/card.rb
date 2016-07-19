class Card < ActiveRecord::Base
  belongs_to :holder, class_name: :AdminUser, foreign_key: :user_id

  def display_name
    holder_name = holder ? holder.name : ''
    card_name = name.empty? ? idm : name
    if holder_name.empty?
      card_name
    else
      "#{holder_name} (#{card_name})"
    end
  end
end
