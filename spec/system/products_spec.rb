require 'rails_helper'

RSpec.describe "Products", type: :system do
  let(:user) { create(:user) }
  let(:product) { create(:product) }

  describe 'ログイン前' do
    describe 'ページ遷移確認' do
      context 'インクの新規登録ページにアクセス' do
        it '新規登録ページへのアクセスに失敗する' do
          visit new_product_path
          expect(page).to have_content 'ログインしてください'
          expect(current_path).to eq new_user_session_path
        end
      end
      context 'インクの詳細ページにアクセス' do
        let!(:sort_review_new) { create(:review, title: '未来の日付のレビュー', product_id: product.id, created_at: 1.day.from_now) }
        let!(:sort_review_old) { create(:review, title: '過去の日付のレビュー', product_id: product.id, created_at: 1.day.ago) }
        let!(:sort_review_like) { create(:review, title: 'いいねの多いレビュー', product_id: product.id, likes_count: 3) }
        it '詳細ページが表示される' do
          visit product_path(product)
          expect(page).to have_content product.name
          expect(current_path).to eq product_path(product)
        end
        it 'インクに紐づいてるレビューが10件まで表示される' do
          review_list = create_list(:review, 7, product_id: product.id)
          visit product_path(product)
          expect(page).to have_content sort_review_new.title
          expect(page).to have_content sort_review_like.title
          expect(page).to have_content review_list[0].title
          expect(page).to have_content review_list[1].title
          expect(page).to have_content review_list[2].title
          expect(page).to have_content review_list[3].title
          expect(page).to have_content review_list[4].title
          expect(page).to have_content review_list[5].title
          expect(page).to have_content review_list[6].title
          expect(page).to have_content sort_review_old.title
        end
        it 'デフォルトでは新着順でレビューが表示される' do
          visit product_path(product)
          within '#sort-test-id' do
            review_titles = all('.card-title').map(&:text)
            expect(review_titles).to eq %W[未来の日付のレビュー いいねの多いレビュー 過去の日付のレビュー]
          end
        end
        it '投稿順をクリックすると、インクに紐づいているレビューが投稿順で表示される' do
          visit product_path(product)
          click_on '投稿順'
          sleep(0.2)
          within '#sort-test-id' do
            review_titles = all('.card-title').map(&:text)
            expect(review_titles).to eq %W[過去の日付のレビュー いいねの多いレビュー 未来の日付のレビュー]
          end
        end
        it '人気順をクリックすると、インクに紐づいているレビューが人気順で表示される' do
          visit product_path(product)
          click_on '人気順'
          sleep(0.2)
          within '#sort-test-id' do
            review_titles = all('.card-title').map(&:text)
            expect(review_titles).to eq %W[いいねの多いレビュー 未来の日付のレビュー 過去の日付のレビュー]
          end
        end
        it '楽天の商品画像とリンクが表示される' do
          rakuten_product = FactoryBot.create(:product, name: '四季織　時雨')
          ActiveJob::Base.queue_adapter = :test
          RakutenDataFetchJob.perform_now(rakuten_product.id)
          visit product_path(rakuten_product)
          expect(page).to have_selector("img[src$='https://thumbnail.image.rakuten.co.jp/ran/img/1001/0004/901/680/184/614/10010004901680184614_1.jpg?_ex=128x128']")
          expect(page).to have_content '楽天で見る'
        end
        it 'メーカー公式リンクと公式通販リンクが表示される' do
          visit product_path(product)
          expect(page).to have_content '公式サイトを見る'
          expect(page).to have_content '公式通販を見る'
        end
      end
    end
  end

  describe 'ログイン後' do
    before { sign_in user }

    describe 'インク新規登録' do
      let!(:reg_product) { create(:product) }
      context 'フォームの入力値が正常' do
        it '登録に成功する' do
          visit new_product_path
          fill_in 'インクの名前', with: 'テストインク'
          fill_in 'メーカー名', with: 'テストメーカー'
          select '青色', from: 'product_category_id'
          click_on '登録する'
          expect(page).to have_content 'インクを登録しました'
          expect(current_path).to eq products_path
        end
      end
      context '既存のインクと同じ名前・違うメーカーで登録' do
        it '登録に成功する' do
          visit new_review_path
          click_on 'インクを選択'
          click_on 'インクを登録する'
          fill_in 'インクの名前', with: reg_product.name
          fill_in 'メーカー名', with: 'テストメーカー'
          select '青色', from: 'product_category_id'
          click_on '登録する'
          expect(page).to have_content 'インクを登録しました'
          expect(current_path).to eq new_review_path
        end
      end
      context '既存のインクと同じメーカー・違う名前で登録' do
        it '登録に成功する' do
          visit new_review_path
          click_on 'インクを選択'
          click_on 'インクを登録する'
          fill_in 'インクの名前', with: 'テストインク'
          fill_in 'メーカー名', with: reg_product.brand.name
          select '青色', from: 'product_category_id'
          click_on '登録する'
          expect(page).to have_content 'インクを登録しました'
          expect(current_path).to eq new_review_path
        end
      end
      context 'インクの名前が未入力' do
        it '登録に失敗する' do
          visit new_review_path
          click_on 'インクを選択'
          click_on 'インクを登録する'
          fill_in 'インクの名前', with: nil
          fill_in 'メーカー名', with: 'テストメーカー名'
          select '青色', from: 'product_category_id'
          click_on '登録する'
          expect(page).to have_content 'インクの登録に失敗しました'
          expect(page).to have_content '1件のエラーが発生しました'
          expect(page).to have_content 'インクの名前を入力してください'
          expect(current_path).to eq new_review_path
        end
      end
      context 'メーカー名が未入力' do
        it '登録に失敗する' do
          visit new_review_path
          click_on 'インクを選択'
          click_on 'インクを登録する'
          fill_in 'インクの名前', with: 'テストインク'
          fill_in 'メーカー名', with: nil
          select '青色', from: 'product_category_id'
          click_on '登録する'
          expect(page).to have_content 'インクの登録に失敗しました'
          expect(page).to have_content '1件のエラーが発生しました'
          expect(page).to have_content 'メーカー名を入力してください'
          expect(current_path).to eq new_review_path
        end
      end
      context 'カテゴリが未選択' do
        it '登録に失敗する' do
          visit new_review_path
          click_on 'インクを選択'
          click_on 'インクを登録する'
          fill_in 'インクの名前', with: 'テストインク'
          fill_in 'メーカー名', with: 'テストメーカー名'
          click_on '登録する'
          expect(page).to have_content 'インクの登録に失敗しました'
          expect(page).to have_content '1件のエラーが発生しました'
          expect(page).to have_content '色系統を選択してください'
          expect(current_path).to eq new_review_path
        end
      end
      context '既存のインクを登録' do
        it '登録に失敗する' do
          visit new_review_path
          click_on 'インクを選択'
          click_on 'インクを登録する'
          fill_in 'インクの名前', with: reg_product.name
          fill_in 'メーカー名', with: reg_product.brand.name
          select '青色', from: 'product_category_id'
          click_on '登録する'
          expect(page).to have_content 'インクの登録に失敗しました'
          expect(page).to have_content '1件のエラーが発生しました'
          expect(page).to have_content 'インクの名前はすでに存在します'
          expect(current_path).to eq new_review_path
        end
      end
    end
  end
end
