class Option < ApplicationRecord
  include Common

  validates :name, presence: true, length: { maximum: 100 }

  belongs_to :user
  belongs_to :poll, touch: true

  mount_uploader :image, ImageUploader
  process_in_background :image

  has_reputation :votes, source: :user, aggregated_by: :sum
end
