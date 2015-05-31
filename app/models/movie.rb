class Movie < ActiveRecord::Base

  has_many :reviews

  # TODO: not working
  mount_uploader :image, ImageUploader

  validates :title,
    presence: true

  validates :director,
    presence: true

  validates :runtime_in_minutes,
    numericality: { only_integer: true }

  validates :description,
    presence: true

 validates :image,
    presence: true 

  # validates :poster_image_url,
  #   presence: true
  # TODO: validate for either :image or :poster_image_url

  validates :release_date,
    presence: true

  validate :release_date_is_in_the_past

  def review_average
    reviews.sum(:rating_out_of_ten)/reviews.size if reviews.size > 0
  end

  def Movie.filter_movie(title, director, duration)
    case duration.to_i
    when 1 then query = "runtime_in_minutes < 90"
    when 2 then query = "runtime_in_minutes BETWEEN 90 and 120"
    when 3 then query = "runtime_in_minutes > 120"
    end
    @movies =  Movie.order(title: :asc)
                    .where('title LIKE ?', "%#{title}%")
                    .where('director LIKE ?', "%#{director}%")
                    .where(query)
  end

  protected

  def release_date_is_in_the_past
    if release_date.present?
      errors.add(:release_date, "should probably be in the past") if release_date > Date.today
    end
  end

end
