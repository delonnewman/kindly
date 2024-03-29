# frozen_string_literal: true

# Coordinate logins and identify users
class User < ApplicationRecord
  belongs_to :team
  has_many :groups, through: :team
  has_many :projects, ->{ joins(:group).order('groups.name, projects.name') }, through: :groups

  has_one :dashboard
  has_many :time_entries

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :trackable, :confirmable

  validates :login, presence: true, uniqueness: true, length: { minimum: 5 }
  before_validation do
    self.login = Login.new(name:, email:) unless login
  end

  def to_s
    name
  end

  def first_name
    name.split(/\s+/).first
  end
  alias nickname first_name

  def date_of_earliest_entry
    time_entries.minimum(:started_at)&.to_date
  end

  def gravatar_url
    hash = Digest::MD5.hexdigest(email)

    "https://www.gravatar.com/avatar/#{hash}"
  end

  def valid_email?
    email.present? && !email.end_with?('@example.com')
  end

  def find_or_create_dashboard
    dashboard || create_dashboard
  end
end
