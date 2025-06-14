require 'rails_helper'

RSpec.describe Review, type: :model do
  before do
    @review = FactoryBot.create(:review)
  end

  describe 'バリデーションテスト' do
    context '失敗パターン' do
      it 'titleが空では投稿できないこと' do
        @review.title = nil
        expect(@review).to be_invalid
      end
      it 'titleが20文字以上だと投稿できないこと' do
        @review.title = 'a' * 22
        expect(@review).to be_invalid
      end
      it 'bodyが空では投稿できないこと' do
        @review.body = nil
        expect(@review).to be_invalid
      end
      it 'bodyが2000文字以上だと投稿できないこと' do
        @review.body = 'a' * 2002
        expect(@review).to be_invalid
      end
      it 'paperが50文字以上だと投稿できないこと' do
        @review.paper = 'a' * 52
        expect(@review).to be_invalid
      end
      it 'penが50文字以上だと投稿できないこと' do
        @review.pen = 'a' * 52
        expect(@review).to be_invalid
      end
      it 'userが空だと投稿できないこと' do
        @review.user = nil
        expect(@review).to be_invalid
      end
      it 'productが空だと投稿できないこと' do
        @review.product = nil
        expect(@review).to be_invalid
      end
      it 'imagesがpng/jpeg/webp以外だと投稿できないこと' do
        @review.images = [fixture_file_upload('spec/fixtures/files/image/dummy_1kb.svg')]
        expect(@review).to be_invalid
      end
      it 'imagesのファイルサイズが3MB以上だと投稿できないこと' do
        @review.images = [fixture_file_upload('spec/fixtures/files/image/dummy_4mb.png')]
        expect(@review).to be_invalid
      end
      it 'imagesの枚数が4枚以上だと投稿できないこと' do
        @review.images = [
          fixture_file_upload('spec/fixtures/files/image/dummy_1kb.png'),
          fixture_file_upload('spec/fixtures/files/image/dummy_1kb.png'),
          fixture_file_upload('spec/fixtures/files/image/dummy_1kb.png'),
          fixture_file_upload('spec/fixtures/files/image/dummy_1kb.png'),
          fixture_file_upload('spec/fixtures/files/image/dummy_1kb.png')
        ]
        expect(@review).to be_invalid
      end
    end
    context '成功パターン' do
      it '設定したすべてのバリデーションが機能していること' do
        @review.images = [
          fixture_file_upload('spec/fixtures/files/image/dummy_1kb.png'),
          fixture_file_upload('spec/fixtures/files/image/dummy_1kb.png'),
          fixture_file_upload('spec/fixtures/files/image/dummy_1kb.png'),
          fixture_file_upload('spec/fixtures/files/image/dummy_1kb.png')
        ]
        expect(@review).to be_valid
        expect(@review.errors).to be_empty
      end
      it 'paper、penが空でも投稿できること' do
        @review.paper = nil
        @review.pen = nil
        expect(@review).to be_valid
        expect(@review.errors).to be_empty
      end
    end
  end
end
