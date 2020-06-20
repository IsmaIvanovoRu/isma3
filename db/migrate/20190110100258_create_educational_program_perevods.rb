class CreateEducationalProgramPerevods < ActiveRecord::Migration
  def change
    create_table :educational_program_perevods do |t|
      t.references :educational_program, index: true, foreign_key: true
      t.integer :number_out_perevod, default: 0
      t.integer :number_to_perevod, default: 0
      t.integer :number_res_perevod, default: 0
      t.integer :number_exp_perevod, default: 0
      t.date :date

      t.timestamps null: false
    end
  end
end
