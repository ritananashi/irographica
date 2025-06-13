require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = FactoryBot.build(:user)
  end

  describe 'バリデーションテスト' do
    context '失敗パターン' do
      it 'nameが空では登録できないこと' do
        @user.name = nil
        expect(@user).to be_invalid
      end
      it 'nameが10文字以上では登録できないこと' do
        @user.name = 'a' * 15
        expect(@user).to be_invalid
      end
      it 'accountが空では登録できないこと' do
        @user.account = nil
        expect(@user).to be_invalid
      end
      it '登録済みのaccountは使用できないこと' do
        @sample_user = FactoryBot.create(:user)
        @user.account = @sample_user.account
        expect(@user).to be_invalid
      end
      it 'accountには半角英数と数字以外使えないこと' do
        @user.account = 'sa+/*-$&mple'
        expect(@user).to be_invalid
      end
      it 'accountが4文字以下では登録できないこと' do
        @user.account = 'a' * 3
        expect(@user).to be_invalid
      end
      it 'accountが20文字以上では登録できないこと' do
        @user.account = 'ab' * 22
        expect(@user).to be_invalid
      end
      it 'emailが空では登録できないこと' do
        @user.email = nil
        expect(@user).to be_invalid
      end
      it '登録済みのメールアドレスは使用できないこと' do
        @sample_user = FactoryBot.create(:user)
        @user.email = @sample_user.email
        expect(@user).to be_invalid
      end
      it 'パスワードが空では登録できないこと' do
        @user.password = nil
        expect(@user).to be_invalid
      end
      it '確認用パスワードとパスワードが一致しないときは登録できないこと' do
        @user.password_confirmation = 'test123'
        expect(@user).to be_invalid
      end
      it 'bodyが500文字以上では登録できないこと' do
        @user.body = 'a' * 501
        expect(@user).to be_invalid
      end
      it 'avatarにpng/jpeg/webp以外のファイルは保存できないこと' do
        @user.avatar = fixture_file_upload('spec/fixtures/files/image/dummy_1kb.svg')
        expect(@user).to be_invalid
      end
      it 'avatarに1MB以上のファイルは保存できないこと' do
        @user.avatar = fixture_file_upload('spec/fixtures/files/image/dummy_2mb.png')
      end
      it 'x_accountにXのURLから始まる文字列以外は入力できないこと' do
        @user.x_account = <<-Test
        javascript:exploit_code();/*
        http://sample.com
        */
        Test
        expect(@user).to be_invalid
      end
      it 'instagram_accountにinstagramのURLから始まる文字列以外は入力できないこと' do
        @user.instagram_account = <<-Test
        javascript:exploit_code();/*
        http://sample.com
        */
        Test
        expect(@user).to be_invalid
      end
      it 'youtube_accountにyoutubeのURLから始まる文字列以外は入力できないこと' do
        @user.youtube_account = <<-Test
        javascript:exploit_code();/*
        http://sample.com
        */
        Test
        expect(@user).to be_invalid
      end
    end
    context '成功パターン' do
      it '設定したすべてのバリデーションが機能していること' do
        @user.avatar = fixture_file_upload('spec/fixtures/files/image/dummy_1kb.png')
        expect(@user).to be_valid
        expect(@user.errors).to be_empty
      end
      it 'body、x_account、instagram_account、youtube_accountが空でも登録できること' do
        @user.body = nil
        @user.x_account = nil
        @user.instagram_account = nil
        @user.youtube_account = nil
        expect(@user).to be_valid
        expect(@user.errors).to be_empty
      end
    end
  end
end
