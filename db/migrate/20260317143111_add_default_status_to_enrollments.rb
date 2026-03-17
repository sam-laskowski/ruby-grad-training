class AddDefaultStatusToEnrollments < ActiveRecord::Migration[7.2]
  def change
    change_column_default :enrollments, :status, from: nil, to: 0
  end
end
