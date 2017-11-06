class Book < ApplicationRecord
  belongs_to :user
  has_many :book_categories
  has_many :categories, :through => :book_categories, :dependent => :destroy
  has_many :reviews

  has_attached_file :book_img, styles: { book_index: "250x250>", book_show: "325x475>" }, default_url: ':placeholder'
  validates_attachment_content_type :book_img, content_type: /\Aimage\/.*\z/
  validates :title, presence: true
  validates :author, presence: true
  validates :categories, presence: true
  
  def self.search key_word
    word = trim key_word, " ."
    where("title LIKE ?", "%#{word}%") 
    where("author LIKE ?", "%#{word}%")
    where("description LIKE ?", "%#{word}%")
  end

  def reviewer_followed_by user
    return nil unless review = reviews.priority(user).most_recent.first
    review.user_id
  end

  private

  def self.trim string, chars
    chars = Regexp.escape chars
    string.gsub /\A[#{chars}]+|[#{chars}]+\z/, ""
  end
end
