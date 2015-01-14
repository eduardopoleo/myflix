shared_examples 'require_sign_in' do
  it 'redirects to the root path is user is unauthenticated' do
    clear_session
    action
    expect(response).to redirect_to signin_path
  end
end
