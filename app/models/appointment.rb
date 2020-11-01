class Appointment < ApplicationRecord
  has_many :appointment_holds, dependent: :destroy
  has_many :appointment_loans, dependent: :destroy
  has_many :holds, through: :appointment_holds
  has_many :loans, through: :appointment_loans
  belongs_to :member

  validate :ends_at_later_than_starts_at, :item_present, :date_present
  attr_accessor :time_range_string

  scope :upcoming, -> { where("starts_at > ?", Time.zone.now).order(:starts_at) }

  private


  def item_present
    if holds.empty? and loans.empty?
      errors.add(:base,"Please select an item to pick-up or return for your appointment")
    end
  end

  def date_present
    if starts_at.nil? or ends_at.nil?
      errors.add(:base,"Please select a date and time for this appointment.")
    end
  end

  def ends_at_later_than_starts_at
    return if ends_at.blank? || starts_at.blank?

    if ends_at < starts_at
      errors.add(:ends_at, "must be after the starts_at date")
    end
  end
end
