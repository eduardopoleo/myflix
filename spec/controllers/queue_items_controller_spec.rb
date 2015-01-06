require 'spec_helper'

describe QueueItemsController do
  describe 'GET index' do
    context 'With authenticated users' do
      let (:current_user ) {Fabricate(:user)} 
      before {session[:user_id] = current_user.id}

      it 'sets the @queue_items variable' do
        video1 = Fabricate(:video)
        video2 = Fabricate(:video)
        item1 = Fabricate(:queue_item, user: current_user, video: video1)
        item2 = Fabricate(:queue_item, user: current_user, video: video2)
        get :index
        expect(assigns(:queue_items)).to match_array([item1, item2])
      end

      it 'renders the index template' do
        get :index
        expect(response).to render_template :index
      end
    end
  end

  describe 'POST create' do
    context 'Authenticated users' do
      let(:current_user) {Fabricate(:user)}
      before do
        session[:user_id] = current_user.id
      end

      it 'redirects to the queue page' do
        video = Fabricate(:video)
        post :create, video_id: video.id
        expect(response).to redirect_to queue_items_path
      end

      it 'creates a queue item' do
        video = Fabricate(:video)
        post :create, video_id: video.id  
        expect(QueueItem.count).to eq(1)
      end

      it 'creates the queue item associated with the video' do
        video = Fabricate(:video, title: 'good video')
        post :create, video_id: video.id
        expect(QueueItem.first.video).to eq(video)
      end

      it 'creates the queue item associated with the current user' do
        video = Fabricate(:video, title: 'good video')
        post :create, video_id: video.id
        expect(QueueItem.first.user).to eq(current_user)
      end

      it 'puts the video as the last one in the queue' do
        video1 = Fabricate(:video)
        Fabricate(:queue_item, video: video1, user: current_user)
        video2 = Fabricate(:video)
        post :create, video_id: video2.id
        expect(video2.queue_items.first.order).to eq(2)
      end

      it 'does not add a video twice to the queue' do
        video1 = Fabricate(:video)
        Fabricate(:queue_item, video: video1, user: current_user)
        post :create, video_id: video1.id
        expect(QueueItem.count).to eq(1)
      end
    end

    it 'redirects to the signin path for unauthenticated users' do
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(response).to redirect_to signin_path
    end
  end

  describe 'DELETE destroy' do
    context 'Authenticated user' do
      let(:current_user) {Fabricate(:user)}
      before do
        session[:user_id] = current_user.id
      end

      it 'redirects to my queue page' do
        video = Fabricate(:video)
        item = Fabricate(:queue_item, video: video)
        delete :destroy, id: item.id
        expect(response).to redirect_to queue_items_path
      end

      it 'deletes the queue item' do
        video = Fabricate(:video)
        item = Fabricate(:queue_item, video: video, user: current_user)
        delete :destroy, id: item.id
        expect(QueueItem.count).to eq(0)
      end

      it 'normalizes the order of items after deleting' do
        video = Fabricate(:video)
        video2 = Fabricate(:video)
        item = Fabricate(:queue_item, video: video, user: current_user, order: 1)
        item2 = Fabricate(:queue_item, video: video2, user: current_user, order: 2)
        delete :destroy, id: item.id
        expect(item2.reload.order).to eq(1)
      end

      it 'does NOT delete the queue item if the item is not in the current user queue' do
        video = Fabricate(:video)
        user2 = Fabricate(:user)
        item = Fabricate(:queue_item, video: video, user: user2)
        delete :destroy, id: item.id
        expect(QueueItem.count).to eq(1)
      end
    end

    it 'redirects to the signin path if the user is not authenticated' do
       video = Fabricate(:video)
       item = Fabricate(:queue_item, video: video)
       delete :destroy, id: item.id
       expect(response).to redirect_to signin_path
    end
  end

  describe 'POST update queue items' do
    context 'with valid inputs' do
      it 'redirects to the my queue page' do
        user = Fabricate(:user)
        session[:user_id] = user.id
        futurama = Fabricate(:video)
        monk = Fabricate(:video)
        queue_item1 = Fabricate(:queue_item, user: user, order: 1, video: futurama)
        queue_item2 = Fabricate(:queue_item, user: user, order: 2, video: monk) 
        post :update_queue, queue_items: [{id: queue_item1.id, order: 2}, {id: queue_item2.id, order: 1}]
        expect(response).to redirect_to queue_items_path
      end

      it 'reorders the queue items' do
        user = Fabricate(:user)
        session[:user_id] = user.id
        futurama = Fabricate(:video)
        monk = Fabricate(:video)
        queue_item1 = Fabricate(:queue_item, user: user, order: 1, video: futurama)
        queue_item2 = Fabricate(:queue_item, user: user, order: 2, video: monk) 
        post :update_queue, queue_items: [{id: queue_item1.id, order: 2}, {id: queue_item2.id, order: 1}]
        expect(user.queue_items).to eq([queue_item2, queue_item1])
      end

      it 'normalizes the position order' do
        user = Fabricate(:user)
        session[:user_id] = user.id
        futurama = Fabricate(:video)
        monk = Fabricate(:video)
        queue_item1 = Fabricate(:queue_item, user: user, order: 1, video: futurama)
        queue_item2 = Fabricate(:queue_item, user: user, order: 2, video: futurama)
        queue_item3 = Fabricate(:queue_item, user: user, order: 3, video: monk) 
        post :update_queue, queue_items: [{id: queue_item1.id, order: 4}, {id: queue_item2.id, order: 2},{id: queue_item3.id, order: 3}]
        expect(user.queue_items.map(&:order)).to eq([1,2,3])
      end
    end

    context 'with invalid inputs' do
      it 'redirects to the my queue page'do
        user = Fabricate(:user)
        session[:user_id] = user.id
        futurama = Fabricate(:video)
        monk = Fabricate(:video)
        queue_item1 = Fabricate(:queue_item, user: user, order: 1, video: futurama)
        queue_item2 = Fabricate(:queue_item, user: user, order: 2, video: futurama)
        queue_item3 = Fabricate(:queue_item, user: user, order: 3, video: monk) 
        post :update_queue, queue_items: [{id: queue_item1.id, order: 4.5}, {id: queue_item2.id, order: 2},{id: queue_item3.id, order: 3}]
        expect(response).to redirect_to queue_items_path
      end

      it 'sets a flash message' do
        user = Fabricate(:user)
        session[:user_id] = user.id
        futurama = Fabricate(:video)
        monk = Fabricate(:video)
        queue_item1 = Fabricate(:queue_item, user: user, order: 1, video: futurama)
        queue_item2 = Fabricate(:queue_item, user: user, order: 2, video: futurama)
        queue_item3 = Fabricate(:queue_item, user: user, order: 3, video: monk) 
        post :update_queue, queue_items: [{id: queue_item1.id, order: 4.5}, {id: queue_item2.id, order: 2},{id: queue_item3.id, order: 3}]
        expect(flash[:error]).to be_present
      end

      it 'does not save the queue'do
        user = Fabricate(:user)
        session[:user_id] = user.id
        futurama = Fabricate(:video)
        monk = Fabricate(:video)
        queue_item1 = Fabricate(:queue_item, user: user, order: 1, video: futurama)
        queue_item2 = Fabricate(:queue_item, user: user, order: 2, video: futurama)
        post :update_queue, queue_items: [{id: queue_item1.id, order: 5}, {id: queue_item2.id, order: 2.3}]
        expect(queue_item1.reload.order).to eq(1)
      end
    end

    context 'aunthenticated users' do
      it 'redirects to the signin path' do 
        futurama = Fabricate(:video)
        monk = Fabricate(:video)
        queue_item1 = Fabricate(:queue_item, order: 1, video: futurama)
        queue_item2 = Fabricate(:queue_item, order: 2, video: futurama)
        post :update_queue, queue_items: [{id: queue_item1.id, order: 5}, {id: queue_item2.id, order: 3}]
        expect(response).to redirect_to signin_path
      end
    end

    context 'with queue items that do not belong to the current user'do
      it 'does not change the queue item' do
        user = Fabricate(:user)
        session[:user_id] = user.id
        user2 = Fabricate(:user)

        futurama = Fabricate(:video)
        monk = Fabricate(:video)

        queue_item1 = Fabricate(:queue_item, user: user, order: 1, video: futurama)
        queue_item2 = Fabricate(:queue_item, user: user2, order: 2, video: futurama)
        post :update_queue, queue_items: [{id: queue_item1.id, order: 5}, {id: queue_item2.id, order: 3}]
        expect(queue_item2.reload.order).to eq(2)
      end
    end
  end
end
