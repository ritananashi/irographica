require 'rails_helper'

RSpec.describe "Brands", type: :system do
  let!(:brand) { create(:brand) }
  let!(:product) { create(:product, brand_id: brand.id) }

  describe 'ログイン前' do
    describe 'ページ遷移確認' do
      context 'メーカーの一覧画面に遷移する' do
        it 'メーカー一覧が表示される' do
          visit brands_path
          expect(page).to have_content brand.name
        end
      end
      context 'メーカー一覧からインクの詳細画面にアクセス' do
        it 'インクの詳細画面に遷移する' do
          visit brands_path
          find('#brand-name').click
          find('#product-name').click
          expect(page).to have_content product.name
          expect(current_path).to eq product_path(product)
        end
      end
    end
  end
end
