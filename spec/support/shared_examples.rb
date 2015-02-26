shared_examples 'require_sign_in' do
  it 'redirects to the root path if user is unauthenticated' do
    clear_session
    action
    expect(response).to redirect_to signin_path
  end
end

shared_examples 'require_admin' do
  it 'redirects to the root path if the user is not and admin' do
    sign_in_integration_test
    action
    expect(response).to redirect_to home_path
  end
end
