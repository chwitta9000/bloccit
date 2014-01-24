class AddPostpicToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :postpic, :string
  end
end
