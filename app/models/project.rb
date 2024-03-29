class Project < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  include PgSearch::Model

  validates :title, presence: true, uniqueness: {
    scope: :user
  }

  validates :content, presence: true
  validate :due_date_cannot_be_earlier_than_start_date

  belongs_to :user, counter_cache: true
  has_and_belongs_to_many :labels

  enum status: %i[todo doing done]
  enum priority: %i[low medium high]

  pg_search_scope :search,
                  against: %i[title content],
                  using: {
                    tsearch: {
                      dictionary: 'english',
                      tsvector_column: 'searchable'
                    }
                  }

  paginates_per 10

  def normalize_friendly_id(input)
    input.to_s.to_slug.normalize(transliterations: :russian).to_s
  end

  priorities.each do |level, _value|
    define_method "#{level}_priority?" do
      send("#{level}?")
    end

    define_method "#{level}_priority!" do
      send("#{level}!")
    end
  end

  def due_date_cannot_be_earlier_than_start_date
    errors.add(:due_date, :cannot_be_earlier_than_start_date) if due_date && start_date && (due_date < start_date)
  end

  def label_str
    self.labels.sort.map { |label| label.name }.join(', ')
  end
end
