require 'rails_helper'

RSpec.describe 'Users', type: :system do
  let(:user) { create(:user) }

  describe 'ログイン前' do
    describe 'ユーザー新規登録' do
      context 'フォームの入力値が正常' do
        it '登録に成功する' do
          visit new_user_registration_path
          fill_in 'ユーザーID', with: 'system_test'
          fill_in 'ユーザー名', with: 'システムテストユーザ'
          fill_in 'Eメール', with: 'system_test@example.com'
          fill_in 'パスワード', with: 'system_test123'
          fill_in 'パスワード（確認用）', with: 'system_test123'
          click_on '登録する'
          expect(page).to have_content '新規登録が完了しました。'
          expect(current_path).to eq root_path
        end
      end
      context 'メールアドレスが未入力' do
        it '登録に失敗する' do
          visit new_user_registration_path
          fill_in 'ユーザーID', with: 'system_test'
          fill_in 'ユーザー名', with: 'システムテストユーザ'
          fill_in 'Eメール', with: nil
          fill_in 'パスワード', with: 'system_test123'
          fill_in 'パスワード（確認用）', with: 'system_test123'
          click_on '登録する'
          expect(page).to have_content '1 件のエラーが発生したため ユーザー は保存されませんでした。'
          expect(page).to have_content 'Eメールを入力してください'
          expect(current_path).to eq new_user_registration_path
        end
      end
      context '登録済みのメールアドレスを入力する' do
        it '登録に失敗する' do
          other_user = create(:user)
          visit new_user_registration_path
          fill_in 'ユーザーID', with: 'system_test'
          fill_in 'ユーザー名', with: 'システムテストユーザ'
          fill_in 'Eメール', with: other_user.email
          fill_in 'パスワード', with: 'system_test123'
          fill_in 'パスワード（確認用）', with: 'system_test123'
          click_on '登録する'
          expect(page).to have_content '1 件のエラーが発生したため ユーザー は保存されませんでした。'
          expect(page).to have_content 'Eメールはすでに存在します'
          expect(page).to have_field 'Eメール', with: other_user.email
          expect(current_path).to eq new_user_registration_path
        end
      end
    end
    describe 'ユーザーの編集' do
      context '未ログイン時' do
        it 'アクセス失敗' do
          visit edit_user_registration_path
          expect(page).to have_content 'ログインもしくはアカウント登録してください。'
          expect(current_path).to eq new_user_session_path
        end
      end
    end
  end

  describe 'ログイン後' do
    before { sign_in user }
    describe 'プロフィール編集' do
      context 'フォームの入力値が正常' do
        it '編集に成功する' do
          visit edit_user_registration_path
          fill_in 'ユーザーID', with: 'test123'
          fill_in 'ユーザー名', with: '編集テスト'
          fill_in 'プロフィール文', with: '編集テスト'
          attach_file 'アイコン', 'spec/fixtures/files/image/dummy_1kb.png'
          fill_in 'Xアカウント', with: 'https://x.com/test'
          fill_in 'instagramアカウント', with: 'https://www.instagram.com/test/'
          fill_in 'YouTubeチャンネル', with: 'https://www.youtube.com/test/'
          click_on '更新する'
          user.account = 'test123'
          expect(page).to have_content 'アカウント情報を変更しました'
          expect(current_path).to eq user_path(user)
        end
      end
      context 'ユーザーIDが未入力' do
        it 'ユーザーの編集が失敗する' do
          visit edit_user_registration_path
          fill_in 'ユーザーID', with: nil
          click_on '更新する'
          expect(page).to have_content '3 件のエラーが発生したため ユーザー は保存されませんでした。'
          expect(page).to have_content 'ユーザーIDを入力してください'
          expect(page).to have_content 'ユーザーIDは不正な値です'
          expect(page).to have_content 'ユーザーIDは4文字以上で入力してください'
          expect(page).to have_field 'ユーザーID', with: nil
          expect(current_path).to eq edit_user_registration_path
        end
      end
      context '登録済のユーザーIDを使用' do
        it 'ユーザーの編集が失敗する' do
          visit edit_user_registration_path
          other_user = create(:user)
          fill_in 'ユーザーID', with: other_user.account
          click_on '更新する'
          expect(page).to have_content '1 件のエラーが発生したため ユーザー は保存されませんでした。'
          expect(page).to have_content 'ユーザーIDはすでに存在します'
          expect(page).to have_field 'ユーザーID', with: other_user.account
          expect(current_path).to eq edit_user_registration_path
        end
      end
    end
    describe 'メールアドレス・パスワード編集' do
      context 'フォームの入力値が正常' do
        it '編集に成功' do
          visit edit_settings_path
          fill_in 'Eメール', with: 'edit_email@example.com'
          fill_in '現在のパスワード', with: user.password
          click_on '更新する'
          expect(page).to have_content '設定を変更しました'
          expect(current_path).to eq edit_settings_path
        end
      end
      context '現在のパスワードが未入力' do
        it '編集に失敗' do
          visit edit_settings_path
          fill_in 'Eメール', with: 'edit_email@example.com'
          fill_in '現在のパスワード', with: nil
          click_on '更新する'
          expect(page).to have_content '1 件のエラーが発生したため ユーザー は保存されませんでした。'
          expect(page).to have_content '現在のパスワードを入力してください'
          expect(current_path).to eq edit_settings_path
        end
      end
      context 'メールアドレスが未入力' do
        it 'メールアドレスの編集が失敗する' do
          visit edit_settings_path
          fill_in 'Eメール', with: nil
          fill_in '現在のパスワード', with: user.password
          click_on '更新する'
          expect(page).to have_content '1 件のエラーが発生したため ユーザー は保存されませんでした。'
          expect(page).to have_content 'Eメールを入力してください'
          expect(page).to have_field 'Eメール', with: nil
          expect(current_path).to eq edit_settings_path
        end
      end
      context '登録済のメールアドレスを使用' do
        it 'メールアドレスの編集が失敗する' do
          other_user = create(:user)
          visit edit_settings_path
          fill_in 'Eメール', with: other_user.email
          fill_in '現在のパスワード', with: user.password
          click_on '更新する'
          expect(page).to have_content '1 件のエラーが発生したため ユーザー は保存されませんでした。'
          expect(page).to have_content 'Eメールはすでに存在します'
          expect(page).to have_field 'Eメール', with: other_user.email
          expect(current_path).to eq edit_settings_path
        end
      end
    end
    describe 'プロフィールページ' do
      context 'レビューを投稿' do
        it '投稿したレビューが表示される' do
          create(:review, title: 'test_title', user: user)
          visit user_path(user)
          expect(page).to have_content 'test_title'
          expect(page).to have_content '詳しく見る'
        end
      end
    end
  end
end
