
OmniAuth.config.test_mode = true

OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
  provider: 'twitter',
  uid: '123545',
  email: 'omniauth_twitter@example.com',
  password: 'test1234',
  info: {
    name: 'omniauth_test_user',
    nickname: 'omniauthtwitter'
  }
})
