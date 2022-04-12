class Book < ApplicationRecord
  has_one_attached :image
  belongs_to :user

  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

# 検索方法分岐
  def self.search_for(content, method)
    if method == 'perfect'
      Book.where(title: content)
    elsif method == 'forward'
      Book.where('title LIKE ?', content+'%')
    elsif method == 'backward'
      Book.where('title LIKE ?', '%'+content)
    else
      Book.where('title LIKE ?', '%'+content+'%')
    end
  end

  validates :title,presence:true
  validates :body,presence:true,length: { minimum: 1, maximum:200}
  
  scope :created_today, -> { where(created_at: Time.zone.now.all_day) } # 今日
  scope :created_yesterday, -> { where(created_at: 1.day.ago.all_day) } # 前日
  
  scope :created_days_ago, ->(n) { where(created_at: n.days.ago.all_day) }
  
  def self.past_week_count
    (1..6).map { |n| created_days_ago(n).count }.reverse
  end
end
