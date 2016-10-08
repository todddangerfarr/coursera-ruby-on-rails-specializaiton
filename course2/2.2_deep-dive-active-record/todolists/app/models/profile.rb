class Profile < ActiveRecord::Base
  belongs_to :user

  validates :gender, :inclusion => {:in => ['male', 'female']}
  validate :first_or_last_required
  validate :male_not_sue

  def first_or_last_required
    if first_name.nil? && last_name.nil?
      errors.add(:first_name, "You must provide either a first or last name.")
    end
  end

  def male_not_sue
    if gender == 'male' && first_name == 'Sue'
      errors.add(:first_name, "cannot be Sue if you are male.")
    end
  end

  def self.get_all_profiles (min_year, max_year)
    Profile.where(:birth_year => min_year..max_year).order(:birth_year)
  end

end
