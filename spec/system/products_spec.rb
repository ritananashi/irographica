require 'rails_helper'

RSpec.describe "Products", type: :system do
  let(:user) { create(:user) }
  let(:review) { create(:review) }
  let(:product) { create(:product) }

  describe 'ログイン前' do
    describe 'ページ遷移確認' do
      context 'インクの新規登録ページにアクセス' do
        it '新規登録ページへのアクセスに失敗する'
      end
      context 'インクの詳細ページにアクセス' do
        it '詳細ページが表示される'
        it 'インクに紐づいてるレビューが新着順で10件まで表示される'
        it '投稿順をクリックすると、インクに紐づいているレビューが投稿順で10件表示される'
        it '人気順をクリックすると、インクに紐づいているレビューが人気順で10件表示される'
        it '楽天の商品画像とリンクが表示される'
        it 'メーカー公式リンクと公式通販リンクが表示される'
      end
    end
  end

  describe 'ログイン後' do
    before { sign_in user }

    describe 'インク新規登録' do
      context 'フォームの入力値が正常' do
        it '登録に成功する'
      end
      context '既存のインクと同じ名前・違うメーカーで登録' do
        it '登録に成功する'
      end
      context '既存のインクと同じメーカー・違う名前で登録' do
        it '登録に成功する'
      end
      context 'インクの名前が未入力' do
        it '登録に失敗する'
      end
      context 'メーカー名が未入力' do
        it '登録に失敗する'
      end
      context 'カテゴリが未選択' do
        it '登録に失敗する'
      end
      context '既存のインクを登録' do
        it '登録に失敗する'
      end
    end
  end
end
