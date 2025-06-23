require 'rails_helper'

RSpec.describe 'Reviews', type: :system do
  let(:user) { create(:user) }
  let(:review) { create(:review) }

  describe 'ログイン前' do
    describe 'ページ遷移確認' do
      context 'レビューの新規投稿ページにアクセス' do
        it '新規投稿ページへのアクセスに失敗する' do
          visit new_review_path
          expect(page).to have_content 'ログインしてください'
          expect(current_path).to eq new_user_session_path
        end
      end
      context 'レビューの編集ページにアクセス' do
        it '編集ページへのアクセスに失敗する' do
          visit edit_review_path(review)
          expect(page).to have_content 'ログインしてください'
          expect(current_path).to eq new_user_session_path
        end
      end
      context 'レビューの詳細ページにアクセス' do
        it '詳細ページが表示される' do
          visit review_path(review)
          expect(page).to have_content review.title
          expect(current_path).to eq review_path(review)
        end
      end
      context 'ルートページにアクセス' do
        it 'レビューが10件表示される' do
          review_list = create_list(:review, 10)
          visit root_path
          expect(page).to have_content review_list[0].title
          expect(page).to have_content review_list[1].title
          expect(page).to have_content review_list[2].title
          expect(page).to have_content review_list[3].title
          expect(page).to have_content review_list[4].title
          expect(page).to have_content review_list[5].title
          expect(page).to have_content review_list[6].title
          expect(page).to have_content review_list[7].title
          expect(page).to have_content review_list[8].title
          expect(page).to have_content review_list[9].title
        end
      end
    end
  end

  describe 'ログイン後' do
    let!(:product) { create(:product) }
    before { sign_in user }

    describe 'レビュー新規投稿' do
      context 'フォームの入力値が正常' do
        it '投稿に成功する' do
          visit new_review_path
          fill_in 'タイトル', with: 'テスト投稿'
          attach_file '画像', 'spec/fixtures/files/image/dummy_1kb.png'
          fill_in '本文', with: 'テスト投稿'
          click_on 'インクを選択'
          click_on 'このインクを選択'
          fill_in '使用した紙', with: 'テスト'
          fill_in '使用したペン', with: 'テスト'
          click_on 'submit'
          expect(page).to have_content 'レビューを投稿しました'
          expect(current_path).to eq root_path
        end
      end
      context 'タイトルが未入力' do
        it '投稿に失敗する' do
          visit new_review_path
          fill_in 'タイトル', with: nil
          fill_in '本文', with: 'テスト投稿'
          click_on 'インクを選択'
          click_on 'このインクを選択'
          fill_in '使用した紙', with: 'テスト'
          fill_in '使用したペン', with: 'テスト'
          click_on 'submit'
          expect(page).to have_content 'レビューの投稿に失敗しました'
          expect(page).to have_content '1件のエラーが発生しました'
          expect(page).to have_content 'タイトルを入力してください'
          expect(current_path).to eq new_review_path
        end
      end
      context '本文が未入力' do
        it '投稿に失敗する' do
          visit new_review_path
          fill_in 'タイトル', with: 'テスト投稿'
          fill_in '本文', with: nil
          click_on 'インクを選択'
          click_on 'このインクを選択'
          fill_in '使用した紙', with: 'テスト'
          fill_in '使用したペン', with: 'テスト'
          click_on 'submit'
          expect(page).to have_content 'レビューの投稿に失敗しました'
          expect(page).to have_content '1件のエラーが発生しました'
          expect(page).to have_content '本文を入力してください'
          expect(current_path).to eq new_review_path
        end
      end
      context 'インクが未入力' do
        it '投稿に失敗する' do
          visit new_review_path
          fill_in 'タイトル', with: 'テスト投稿'
          fill_in '本文', with: 'テスト投稿'
          fill_in '使用した紙', with: 'テスト'
          fill_in '使用したペン', with: 'テスト'
          click_on 'submit'
          expect(page).to have_content 'レビューの投稿に失敗しました'
          expect(page).to have_content '1件のエラーが発生しました'
          expect(page).to have_content 'インクは「インクを選択」から選んでください'
          expect(current_path).to eq new_review_path
        end
      end
      context 'オリジナルインクを選択' do
        it 'インクレシピ入力欄が表示される' do
          visit new_review_path
          fill_in 'インク', with: 'オリジナル'
          first("body").click
          expect(page).to have_content 'インクレシピ'
        end
      end
    end

    describe 'レビュー編集' do
      let!(:review) { create(:review, user: user) }
      before { visit edit_review_path(review) }

      context 'フォームの入力値が正常' do
        it '編集に成功する' do
          fill_in 'タイトル', with: '編集テスト'
          attach_file '画像', 'spec/fixtures/files/image/dummy_1kb.png'
          fill_in '本文', with: '編集テスト'
          click_on 'submit'
          expect(page).to have_content 'レビューを編集しました'
          expect(current_path).to eq review_path(review)
        end
      end
      context 'タイトルが未入力' do
        it '投稿に失敗する' do
          fill_in 'タイトル', with: nil
          click_on 'submit'
          expect(page).to have_content 'レビューの編集に失敗しました'
          expect(page).to have_content '1件のエラーが発生しました'
          expect(page).to have_content 'タイトルを入力してください'
          expect(current_path).to eq edit_review_path(review)
        end
      end
      context '本文が未入力' do
        it '投稿に失敗する' do
          fill_in '本文', with: nil
          click_on 'submit'
          expect(page).to have_content 'レビューの編集に失敗しました'
          expect(page).to have_content '1件のエラーが発生しました'
          expect(page).to have_content '本文を入力してください'
          expect(current_path).to eq edit_review_path(review)
        end
      end
      context 'オリジナルインクを選択' do
        it 'インクレシピ入力欄が表示される' do
          visit new_review_path
          fill_in 'インク', with: 'オリジナル'
          first("body").click
          expect(page).to have_content 'インクレシピ'
        end
      end
      context '他ユーザーのレビュー編集ページにアクセス' do
        let!(:other_user) { create(:user) }
        let!(:other_review) { create(:review, user: other_user) }
        it 'アクセスに失敗する' do
          visit edit_review_path(other_review)
          expect(page).to have_content 'アクセスできません'
          expect(current_path).to eq root_path
        end
      end
    end

    describe 'レビュー削除' do
      let!(:review) { create(:review, user: user) }

      it 'レビューの削除に成功する' do
        visit review_path(review)
        click_on '削除'
        expect(page.accept_confirm).to eq '投稿を削除しますか？'
        expect(page).to have_content '投稿を削除しました'
        expect(current_path).to eq root_path
        expect(page).not_to have_content review.title
      end
    end
  end
end
