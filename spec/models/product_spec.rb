require 'rails_helper'

RSpec.describe Product, type: :model do
  before do
    @product = FactoryBot.build(:product)
  end

  describe 'バリデーションテスト' do
    context '失敗パターン' do
      it 'カテゴリーが選択されてないと登録できないこと' do
        @product.category = nil
        expect(@product).to be_invalid
      end
      it 'ブランドが選択されていないと登録できないこと' do
        @product.brand = nil
        expect(@product).to be_invalid
      end
      it '同じインク名とブランドの組合せで登録できないこと' do
        @sample_product = FactoryBot.create(:product)
        @product.name = @sample_product.name
        @product.brand = @sample_product.brand
        expect(@product).to be_invalid
      end
    end

    context '成功パターン' do
      it '設定したすべてのバリデーションが機能していること' do
        @sample_product = FactoryBot.create(:product)
        @product.brand = @sample_product.brand
        expect(@product).to be_valid
        expect(@product.errors).to be_empty
      end
    end
  end
end
