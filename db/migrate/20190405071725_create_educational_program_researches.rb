class CreateEducationalProgramResearches < ActiveRecord::Migration
  def change
    create_table :educational_program_researches do |t|
      t.references :educational_program, index: { name: :educational_program_researches_index}, foreign_key: true
      t.text :perechen_nir
      t.text :base_nir
      t.integer :npr_nir, default: 0
      t.integer :stud_nir, default: 0
      t.integer :monograf_nir, default: 0
      t.integer :article_nir, default: 0
      t.integer :patent_r_nir, default: 0
      t.integer :patent_z_nir, default: 0
      t.integer :svid_r_nir, default: 0
      t.integer :svid_z_nir, default: 0
      t.integer :finance_nir, default: 0
      t.date :date

      t.timestamps null: false
    end
  end
end
