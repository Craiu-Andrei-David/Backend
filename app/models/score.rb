# Model to represent a score played by a golfer
# - total_score: total number of hits to finish all 18 holes
# - played_at: date when the score was played
class Score < ApplicationRecord
  belongs_to :user

  before_validation :set_number_of_holes

  validates :total_score, inclusion: { in: 54..120 }
  validates :number_of_holes, inclusion: {in: [9,18]}
  validate :future_score

  def serialize
    {
      id: id,
      user_id: user_id,
      user_name: user.name,
      total_score: total_score,
      played_at: played_at,
      number_of_holes: number_of_holes,
    }
  end

  private

  def future_score
    errors.add(:played_at, 'must not be in the future') if played_at > Time.zone.today
  end

  def score_in_range
    score_min = number_of_holes == 9 ? 27 : 54
    score_max = number_of_holes == 9 ? 90 : 180

    if (total_score < score_min || total_score >= score_max)
      errors.add(:total_score, "must be between #{score_min} and #{score_max} for #{number_of_holes} holes")
    end
  end

  def set_number_of_holes
    return if number_of_holes.present?
    self.number_of_holes = total_score < 90 ? 9 : 18
  end
end
