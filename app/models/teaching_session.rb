# frozen_string_literal: true
# == Schema Information
#
# Table name: teaching_sessions
#
#  id         :bigint(8)        not null, primary key
#  start_time :time
#  tutor_id   :bigint(8)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  hour_id    :bigint(8)
#  start_date :date
#

class TeachingSession < ApplicationRecord
  after_create :create_report

  belongs_to :tutor, class_name: 'User'
  belongs_to :hour

  has_many :questions
  has_many :interests, dependent: :destroy
  has_one :report, dependent: :destroy

  scope :in_range, lambda { |start, finish|
    where(['start_date >= ? and start_date < ?', start.to_date, finish.to_date])
  }

  def self.create_with_type(params:, type:, until_date:)
    case type
    when 'today'
      TeachingSession.create(params)
    when 'weekly'
      period_start = params[:start_date].to_date
      period_end = until_date.to_date
      tutor_id = params[:tutor_id]
      hour_id = params[:hour_id]
      teaching_sessions = []

      period_start.step(period_end, 7) do |day|
        teaching_sessions << { tutor_id: tutor_id, hour_id: hour_id, start_date: day }
      end

      TeachingSession.create(teaching_sessions)
    end
  end

  def create_report
    Report.create(teaching_session_id: id, completed: false)
  end

  def self.update_with_type(session:, type:, params:, until_date:)
    case type
    when 'today'
      session.update(params)
    when 'weekly'
      period_start = params[:start_date].to_date
      period_end = until_date.to_date
      period = period_start.step(period_end, 7).to_a
      tutor_id = params[:tutor_id]
      hour_id = params[:hour_id]

      TeachingSession.where(tutor_id: session.tutor_id, hour_id: session.hour_id, start_date: period)
                     .update_all(tutor_id: tutor_id, hour_id: hour_id)
    end
  end

  def self.destroy_with_type(session:, type:, until_date:)
    case type
    when 'today'
      session.destroy
    when 'weekly'
      period_start = session.start_date.to_date
      period_end = until_date.to_date
      period = period_start.step(period_end, 7).to_a

      TeachingSession.where(tutor_id: session.tutor_id, hour_id: session.hour_id, start_date: period)
                     .destroy_all
    end
  end

  def to_json
    { id: id, hour_id: hour.id, start_date: start_date.strftime('%Y.%-m.%-e'),
      tutor_f_name: tutor.first_name, tutor_id: tutor_id, courses: tutor.expertises.joins(:course).pluck(:name) }
  end
end
