class Stamp < ActiveRecord::Base

  scope :can_giveaway, -> { where(giveaway: nil) }
  scope :can_damage, -> { where(damage: nil) }
  scope :inventory, -> { can_damage.can_giveaway }
  scope :available, -> { inventory.order('created_at DESC').limit(2) }

  scope :giveaways, -> { count(:giveaway) }
  scope :damages, -> { count(:damage) }

	before_create :set_devkit_to_today

  def set_devkit_to_today
    self.devkit = Date.today
  end

  def self.search(query)
    # if search
      query = query.values.join("-")
      query = Date.parse(query)
      start_date = query.beginning_of_month
      end_date = query.end_of_month
      where("created_at >= ? AND created_at <= ?", start_date, end_date)
    # active model scopes
    # else
    #   scoped
    # end
  end

end
