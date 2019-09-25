# == Schema Information
#
# Table name: apparels
#
#  id          :integer          not null, primary key
#  user_id     :integer          not null
#  title       :string           not null
#  description :text
#  size_info   :string
#  gender      :string
#  age_info    :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  deleted_at  :datetime
#

require 'securerandom'

class Apparel < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :user

  acts_as_mappable :through => :user

  has_many :apparel_images, -> { order('sort_order ASC') }, dependent: :destroy
  accepts_nested_attributes_for :apparel_images, :allow_destroy => true

  has_many :apparel_tags, dependent: :destroy
  accepts_nested_attributes_for :apparel_tags, :allow_destroy => true

  has_one :apparel_property, dependent: :destroy
  accepts_nested_attributes_for :apparel_property, :allow_destroy => true

  has_many :apparel_ratings, dependent: :destroy
  has_many :apparel_reports, dependent: :destroy
  has_many :chat_apparels, dependent: :destroy

  before_save :set_old_properties

  validate :check_same_name
  validates_presence_of :title, :user

  def main_image
    self.apparel_images.first
  end

  def similars
    self.user.apparels.where(title: self.title, description: self.description).where.not(id: self.id)
  end

  def report(user, reason)
    self.apparel_reports.create(user: user, number: SecureRandom.hex(16), reason: reason)
  end

  def tag_names
    apparel_tags.map { |t| '#' + t.global_tag.name }
  end

  def tag_names=(value)
    return if !value
    
    value.map do |name| 
      self.apparel_tags.find_or_initialize_by(global_tag: GlobalTag.find_or_create_by(name: name))
    end
  end

  def matches
    self.chat_apparels.count
  end

  def likes
    self.apparel_ratings.where(liked: true).count
  end

  def deslikes
    self.apparel_ratings.where.not(liked: true).count
  end

  def last_month_matches
    self.chat_apparels.where('created_at > ?', Time.now - 1.month).count
  end

  def last_month_likes
    self.apparel_ratings.where('created_at > ?', Time.now - 1.month).where(liked: true).count
  end

  def last_month_deslikes
    self.apparel_ratings.where('created_at > ?', Time.now - 1.month).where.not(liked: true).count
  end

  def self.to_csv
    custom_column_names = ["titulo", "descrição", "tamanho", "genero", "idade", "tags", "id peça", "email dono", "nome dono", "id dono"]
    CSV.generate do |csv|
      csv << custom_column_names
      all.each do |apparel|
        csv << [apparel.title, apparel.description, apparel.size_info, apparel.gender, apparel.age_info, apparel.tag_names.join(' '), apparel.id.to_s, apparel.user.email, apparel.user.name, apparel.user_id.to_s]
      end
    end
  end

  protected
    def set_old_properties
      if self.apparel_property
        self.age_info = self.apparel_property.size_group.name if self.apparel_property.size_group
        self.size_info = self.apparel_property.size.name if self.apparel_property.size
        self.gender = self.apparel_property.model.name if self.apparel_property.model
      end
    end

    def check_same_name
      if self.similars.count > 0
        errors.add(:title, :duplicate)
        return false
      end
    end
end
