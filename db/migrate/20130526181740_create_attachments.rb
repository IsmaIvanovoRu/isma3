class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.references :article, index: true
      t.string :title, :null => false, :default => ""
      t.string :mime_type, :null => false, :default => ""
      t.binary :data, :null => false, :default => ""
      t.binary :thumbnail, :null => false, :default => ""
      t.text :content, :null => false, :default => ""

      t.timestamps
    end
  end
end
