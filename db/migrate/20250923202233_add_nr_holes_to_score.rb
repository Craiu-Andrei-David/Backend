class AddNrHolesToScore < ActiveRecord::Migration[6.1]
  def change
    add_column :scores, :number_of_holes, :integer
  end

  def update
    Score.where(number_of_holes: nil).find_each do |score|
      score.update_columns(number_of_holes: score.total_score < 90 ? 9 : 18)
  end
end
