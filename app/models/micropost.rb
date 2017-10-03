class Micropost < ApplicationRecord
  belongs_to :user
  default_scope ->{order(created_at: :desc)}
  scope :feed_user_id, ->(id){where user_id: id}
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.micropost.content.max_length}
  validate  :picture_size

  def picture_size
    return unless picture.size > Settings.image.size.megabytes
    errors.add(:picture, I18n.t("micropost.eror"))
  end
end
