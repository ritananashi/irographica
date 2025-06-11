require 'rails_helper'

RSpec.describe "Statics", type: :system do
  describe "静的ページの表示テスト" do
    it "ルートページが表示されること" do
      visit root_path
      expect(page).to have_content "レビューを見る"
    end
  end
end
