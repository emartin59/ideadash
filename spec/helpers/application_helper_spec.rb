require 'rails_helper'

# describe ApplicationHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe ApplicationHelper, type: :helper do
  describe "flash_messages" do
    it 'turns all messages into alert boxes' do
      allow_any_instance_of(ActionDispatch::Request).to receive(:flash).and_return( {
        success: 'User successfully created!',
        danger: 'User already exists'
      })
      expect(helper.flash_messages).to eq <<-HTML.chomp
<div class=\"alerts\"><div class="alert alert-success" role="alert"><button type="button" class="close" data-dismiss="alert">
  <span aria-hidden="true">&times;</span>
  <span class="sr-only">Close</span>
</button>
User successfully created!</div><div class="alert alert-danger" role="alert"><button type="button" class="close" data-dismiss="alert">
  <span aria-hidden="true">&times;</span>
  <span class="sr-only">Close</span>
</button>
User already exists</div></div>
HTML
    end
  end
end
