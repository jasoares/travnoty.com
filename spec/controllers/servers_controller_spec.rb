require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe ServersController do

  # This should return the minimal set of attributes required to create a valid
  # Server. As you add validations to Server, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    FactoryGirl.attributes_for(:server)
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ServersController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all servers as @servers" do
      server = Server.create! valid_attributes
      get :index, {}, valid_session
      assigns(:servers).should eq([server])
    end
  end

  describe "GET show" do
    it "assigns the requested server as @server" do
      server = Server.create! valid_attributes
      get :show, {:id => server.to_param}, valid_session
      assigns(:server).should eq(server)
    end
  end

  # describe "GET new" do
  #   it "assigns a new server as @server" do
  #     get :new, {}, valid_session
  #     assigns(:server).should be_a_new(Server)
  #   end
  # end

  # describe "GET edit" do
  #   it "assigns the requested server as @server" do
  #     server = Server.create! valid_attributes
  #     get :edit, {:id => server.to_param}, valid_session
  #     assigns(:server).should eq(server)
  #   end
  # end

  # describe "POST create" do
  #   describe "with valid params" do
  #     it "creates a new Server" do
  #       expect {
  #         post :create, {:server => valid_attributes}, valid_session
  #       }.to change(Server, :count).by(1)
  #     end

  #     it "assigns a newly created server as @server" do
  #       post :create, {:server => valid_attributes}, valid_session
  #       assigns(:server).should be_a(Server)
  #       assigns(:server).should be_persisted
  #     end

  #     it "redirects to the created server" do
  #       post :create, {:server => valid_attributes}, valid_session
  #       response.should redirect_to(Server.last)
  #     end
  #   end

  #   describe "with invalid params" do
  #     it "assigns a newly created but unsaved server as @server" do
  #       # Trigger the behavior that occurs when invalid params are submitted
  #       Server.any_instance.stub(:save).and_return(false)
  #       post :create, {:server => { "index" => "invalid value" }}, valid_session
  #       assigns(:server).should be_a_new(Server)
  #     end

  #     it "re-renders the 'new' template" do
  #       # Trigger the behavior that occurs when invalid params are submitted
  #       Server.any_instance.stub(:save).and_return(false)
  #       post :create, {:server => { "index" => "invalid value" }}, valid_session
  #       response.should render_template("new")
  #     end
  #   end
  # end

  # describe "PUT update" do
  #   describe "with valid params" do
  #     it "updates the requested server" do
  #       server = Server.create! valid_attributes
  #       # Assuming there are no other servers in the database, this
  #       # specifies that the Server created on the previous line
  #       # receives the :update_attributes message with whatever params are
  #       # submitted in the request.
  #       Server.any_instance.should_receive(:update_attributes).with({ "index" => "MyString" })
  #       put :update, {:id => server.to_param, :server => { "index" => "MyString" }}, valid_session
  #     end

  #     it "assigns the requested server as @server" do
  #       server = Server.create! valid_attributes
  #       put :update, {:id => server.to_param, :server => valid_attributes}, valid_session
  #       assigns(:server).should eq(server)
  #     end

  #     it "redirects to the server" do
  #       server = Server.create! valid_attributes
  #       put :update, {:id => server.to_param, :server => valid_attributes}, valid_session
  #       response.should redirect_to(server)
  #     end
  #   end

  #   describe "with invalid params" do
  #     it "assigns the server as @server" do
  #       server = Server.create! valid_attributes
  #       # Trigger the behavior that occurs when invalid params are submitted
  #       Server.any_instance.stub(:save).and_return(false)
  #       put :update, {:id => server.to_param, :server => { "index" => "invalid value" }}, valid_session
  #       assigns(:server).should eq(server)
  #     end

  #     it "re-renders the 'edit' template" do
  #       server = Server.create! valid_attributes
  #       # Trigger the behavior that occurs when invalid params are submitted
  #       Server.any_instance.stub(:save).and_return(false)
  #       put :update, {:id => server.to_param, :server => { "index" => "invalid value" }}, valid_session
  #       response.should render_template("edit")
  #     end
  #   end
  # end

  # describe "DELETE destroy" do
  #   it "destroys the requested server" do
  #     server = Server.create! valid_attributes
  #     expect {
  #       delete :destroy, {:id => server.to_param}, valid_session
  #     }.to change(Server, :count).by(-1)
  #   end

  #   it "redirects to the servers list" do
  #     server = Server.create! valid_attributes
  #     delete :destroy, {:id => server.to_param}, valid_session
  #     response.should redirect_to(servers_url)
  #   end
  # end

end
